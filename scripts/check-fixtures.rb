#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "yaml"

CONFIDENCE = {"LOW" => 1, "MEDIUM" => 2, "HIGH" => 3}.freeze
VERIFICATION = %w[VERIFIED CODE_PROVEN SUSPECTED].freeze
CLAIM_STATUSES = %w[VERIFIED PARTIALLY_VERIFIED UNVERIFIED CONTRADICTED].freeze

options = {root: File.expand_path("..", __dir__), results: nil}
OptionParser.new do |parser|
  parser.banner = "usage: check-fixtures.rb [--results DIRECTORY]"
  parser.on("--results DIRECTORY", "Read <directory>/<fixture>/regression.yaml instead of checked-in observed.yaml") { |value| options[:results] = File.expand_path(value) }
end.parse!

def load_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: false) || {}
rescue Errno::ENOENT
  raise "missing result: #{path}"
rescue Psych::Exception => error
  raise "invalid YAML #{path}: #{error.message}"
end

def validate_expected!(expected, path)
  %w[fixture profiles must_find must_not_find expected_claims maximum_false_positives].each do |key|
    raise "#{path}: missing #{key}" unless expected.key?(key)
  end
  raise "#{path}: must_find must be an array" unless expected["must_find"].is_a?(Array)
  raise "#{path}: must_not_find must be an array" unless expected["must_not_find"].is_a?(Array)
  profiles = expected["profiles"]
  valid_profiles = %w[core frontend-web backend-general spring-backend python-backend node-backend]
  raise "#{path}: profiles must include core" unless profiles.is_a?(Array) && profiles.include?("core")
  raise "#{path}: invalid profile" unless profiles.all? { |profile| valid_profiles.include?(profile) }
  specializations = %w[spring-backend python-backend node-backend]
  if (profiles & specializations).any? && !profiles.include?("backend-general")
    raise "#{path}: backend specialization requires backend-general"
  end
  expected["must_find"].each do |item|
    %w[category concepts minimum_confidence allowed_verification_levels minimum_evidence].each do |key|
      raise "#{path}: must_find missing #{key}" unless item.key?(key)
    end
    raise "#{path}: invalid confidence" unless CONFIDENCE.key?(item["minimum_confidence"])
    raise "#{path}: invalid verification level" unless item["allowed_verification_levels"].all? { |level| VERIFICATION.include?(level) }
  end
  expected["expected_claims"].each do |claim|
    raise "#{path}: invalid claim status" unless CLAIM_STATUSES.include?(claim["status"])
  end
end

def core_match?(expected, actual)
  actual["category"] == expected["category"] &&
    Array(expected["concepts"]).all? { |concept| Array(actual["concepts"]).include?(concept) }
end

def quality_errors(expected, actual)
  errors = []
  actual_confidence = CONFIDENCE.fetch(actual["confidence"], 0)
  minimum_confidence = CONFIDENCE.fetch(expected["minimum_confidence"])
  errors << "confidence #{actual["confidence"] || "missing"} is below #{expected["minimum_confidence"]}" if actual_confidence < minimum_confidence
  unless expected["allowed_verification_levels"].include?(actual["verification_level"])
    errors << "verification #{actual["verification_level"] || "missing"} is not allowed"
  end
  evidence_count = Array(actual["evidence"]).length
  errors << "evidence count #{evidence_count} is below #{expected["minimum_evidence"]}" if evidence_count < expected["minimum_evidence"]
  errors
end

def forbidden_match?(rule, finding)
  checks = []
  checks << Array(finding["concepts"]).include?(rule["concept"]) if rule.key?("concept")
  checks << finding["category"] == rule["category"] if rule.key?("category")
  if rule.key?("title_pattern")
    checks << !!(finding["title"].to_s =~ Regexp.new(rule["title_pattern"], Regexp::IGNORECASE))
  end
  !checks.empty? && checks.all?
rescue RegexpError
  false
end

fixture_root = File.join(options[:root], "fixtures")
expected_files = Dir[File.join(fixture_root, "**", "expected.yaml")].sort
abort "No fixture expectations found" if expected_files.empty?

totals = Hash.new(0)
failed = false

expected_files.each do |expected_path|
  expected = load_yaml(expected_path)
  validate_expected!(expected, expected_path)
  name = expected.fetch("fixture")
  result_path = if options[:results]
                  File.join(options[:results], name, "regression.yaml")
                else
                  File.join(File.dirname(expected_path), "observed.yaml")
                end

  errors = []
  begin
    observed = load_yaml(result_path)
  rescue StandardError => error
    observed = {"findings" => [], "claims" => []}
    errors << error.message
  end

  errors << "fixture name mismatch in #{result_path}" unless observed["fixture"] == name
  expected_profiles = Array(expected["profiles"]).sort
  observed_profiles = Array(observed["profiles"]).sort
  if observed_profiles != expected_profiles
    errors << "Wrong profile: expected #{expected_profiles.join(", ")}, got #{observed_profiles.empty? ? "missing" : observed_profiles.join(",") }"
    totals[:wrong_profiles] += 1
  end
  findings = Array(observed["findings"])
  matched_indices = []
  found_expected = 0

  expected["must_find"].each do |required|
    candidates = findings.each_index.select { |index| core_match?(required, findings[index]) && !matched_indices.include?(index) }
    passing = candidates.find { |index| quality_errors(required, findings[index]).empty? }
    if passing
      matched_indices << passing
      found_expected += 1
    else
      detail = candidates.empty? ? "no category/concept match" : quality_errors(required, findings[candidates.first]).join(", ")
      errors << "Missed finding: #{required["category"]} / #{required["concepts"].join(", ")} (#{detail})"
    end
  end

  forbidden = []
  findings.each do |finding|
    expected["must_not_find"].each do |rule|
      forbidden << [finding, rule] if forbidden_match?(rule, finding)
    end
    if Array(expected["forbidden_categories"]).include?(finding["category"])
      forbidden << [finding, {"category" => finding["category"]}]
    end
  end
  forbidden.uniq.each do |finding, rule|
    errors << "Forbidden finding #{finding["id"] || finding["title"]}: matched #{rule.inspect}"
  end

  unexpected_indices = findings.each_index.reject { |index| matched_indices.include?(index) }
  unexpected_indices.each do |index|
    finding = findings[index]
    errors << "Unexpected finding #{finding["id"] || "unknown"}: #{finding["title"] || finding["concepts"]}"
  end
  if unexpected_indices.length > expected["maximum_false_positives"]
    errors << "False positives #{unexpected_indices.length} exceed maximum #{expected["maximum_false_positives"]}"
  end

  claims = Array(observed["claims"])
  correct_claims = 0
  expected["expected_claims"].each do |required|
    actual = claims.find { |claim| claim["id"] == required["id"] }
    if actual && actual["status"] == required["status"]
      correct_claims += 1
    else
      errors << "Claim #{required["id"]}: expected #{required["status"]}, got #{actual&.fetch("status", nil) || "missing"}"
    end
  end

  totals[:expected] += expected["must_find"].length
  totals[:found] += found_expected
  totals[:missed] += expected["must_find"].length - found_expected
  totals[:unexpected] += unexpected_indices.length
  totals[:forbidden] += forbidden.map(&:first).uniq.length
  totals[:claims] += expected["expected_claims"].length
  totals[:correct_claims] += correct_claims
  totals[:observed] += findings.length

  if errors.empty?
    puts format("%-26s PASS", name)
  else
    failed = true
    puts format("%-26s FAIL", name)
    errors.each { |error| puts "  - #{error}" }
  end
end

precision = totals[:observed].zero? ? 1.0 : totals[:found].fdiv(totals[:observed])
recall = totals[:expected].zero? ? nil : totals[:found].fdiv(totals[:expected])
claim_accuracy = totals[:claims].zero? ? nil : totals[:correct_claims].fdiv(totals[:claims])

puts
puts "Expected Findings: #{totals[:expected]}"
puts "Found Expected Findings: #{totals[:found]}"
puts "Missed Findings: #{totals[:missed]}"
puts "Unexpected Findings: #{totals[:unexpected]}"
puts "Forbidden Findings: #{totals[:forbidden]}"
puts "Wrong Profiles: #{totals[:wrong_profiles]}"
puts format("Claim Verification Accuracy: %s", claim_accuracy ? format("%.1f%% (%d/%d)", claim_accuracy * 100, totals[:correct_claims], totals[:claims]) : "N/A")
puts format("Precision (development signal): %.3f", precision)
puts format("Recall (development signal): %s", recall ? format("%.3f", recall) : "N/A")
puts "False Positive Count: #{totals[:unexpected]}"
puts "Small fixture counts are calibration signals, not statistically stable quality estimates."

exit(failed ? 1 : 0)
