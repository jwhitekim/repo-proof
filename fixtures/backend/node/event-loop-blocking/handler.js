import { pbkdf2Sync } from "node:crypto";

export function passwordPreviewHandler(request, response) {
  const preview = pbkdf2Sync(
    request.body.password,
    "fixture-salt",
    2_000_000,
    64,
    "sha512",
  ).toString("hex");
  response.json({ preview });
}

