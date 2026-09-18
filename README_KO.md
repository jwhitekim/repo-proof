# RepoProof

한국어 | [English](README.md)

> RepoProof는 **“이 코드가 동작하는가?”**만 묻지 않습니다.  
> RepoProof는 **“이 구현이 기존 저장소를 존중하고 타당한 엔지니어링 결정을 내렸으며, 그 결정을 증거로 설명할 수 있는가?”**를 묻습니다.

RepoProof는 저장소 전체를 대상으로 하는 증거 기반 소프트웨어 엔지니어링 검증 프로젝트입니다. 저장소 이해, 책임과 의존성, 상태 소유권, abstraction 품질, 변경 규율, 유지보수성, 기술적 주장을 검증합니다. lint, formatter, naming 검사기, 일반 버그 리뷰 또는 SOLID 이름을 붙이는 체크리스트가 아닙니다.

## Core와 영역별 Profile

분석 가능한 모든 영역에는 Core profile을 적용합니다. 그다음 repository-recon이 저장소 전체를 하나의 유형으로 분류하지 않고, 증거에 따라 영역별 profile을 추가합니다.

```text
frontend/  -> Core + Frontend Web
server/    -> Core + Backend General (+ 확인된 runtime specialization)
shared/    -> Core
```

따라서 fullstack 저장소도 실제 경계를 유지합니다. 근거가 부족한 영역은 `UNKNOWN` 또는 `MIXED`로 남기며, Frontend 코드에 Backend 규칙을 강제하지 않습니다.

### Core Software Engineering

- Repository Understanding: 기존 함수, 모듈, component, hook, utility, service, domain rule, extension point 재사용
- Design Integrity: 책임, 응집도, 결합도, 캡슐화, 의존성 방향, abstraction 품질, single source of truth
- Change Discipline: 요구 범위에 비례한 변경, 불필요한 재설계와 public surface 확대 방지
- Code Quality: 실제 결과가 있는 control/data flow와 계약의 유지보수성

언어와 framework의 관용적 구조를 고려합니다. 캡슐화는 함수, 모듈, closure, component, class 또는 데이터 경계에 존재할 수 있습니다. interface가 없다는 사실은 결함이 아닙니다.

### Frontend Web Profile

Component/module 책임, 기존 hook/component/API client 재사용, 상태 소유권, derived/stale state, async race, 중복 fetching, effect/lifecycle, cancellation과 cleanup, UI/domain logic 경계를 검증합니다. memoization 부재, 일반적인 render, component 크기, prop drilling 자체는 finding이 아닙니다.

### Backend General Profile

알고리즘과 자료구조, 시간·공간 복잡도, DB/query/index, transaction/concurrency/lock, network/I/O, timeout/retry/idempotency, worker/event loop, pool/backpressure, cache/distributed concern, performance, resource exhaustion, observability를 검증합니다. 기술을 사용하지 않았다는 이유로 감점하지 않습니다.

Backend General은 언어 중립적이며 다음 specialization이 같은 category를 runtime에 맞게 해석합니다.

- `spring-backend-v1`: Spring/Spring Boot/JPA/Hibernate의 proxy, transaction, fetch semantics
- `python-backend-v1`: asyncio, GIL, WSGI/ASGI worker, coroutine/session lifecycle, Python ORM
- `node-backend-v1`: Node.js event loop, Promise/task ownership, stream/backpressure, worker/process, Node ORM

## 검증 모드

**Repository Audit**은 현재 저장소를 영역별로 검증합니다.

**Change Review**는 `base...head`를 비교하고 기존 코드와 abstraction을 문맥으로 사용하되, 변경에서 새로 발생하거나 악화된 engineering decision만 평가합니다. 일반적인 PR 버그 리뷰가 아닙니다.

## Evidence 모델

모든 주요 finding은 [`finding.schema.json`](schemas/finding.schema.json)을 따르고 가능한 경우 area/profile을 기록합니다.

- `VERIFIED`: 기록된 안전한 방법으로 직접 재현하거나 측정함
- `CODE_PROVEN`: 코드·설정과 구체적인 호출/데이터 경로로 논리적으로 확인됨
- `SUSPECTED`: runtime, traffic, data 또는 환경 정보가 더 필요함

Severity와 confidence는 독립적입니다. 대표성 있는 측정 없이 성능 문제나 개선을 VERIFIED로 처리하지 않습니다. 기술적 claim은 `VERIFIED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, `CONTRADICTED`로 분류합니다.

## Rubric과 Scoring

- [`core-v1.yaml`](rubrics/core-v1.yaml): 모든 분석 가능 영역
- [`frontend-web-v1.yaml`](rubrics/frontend-web-v1.yaml): Frontend 영역
- [`backend-v1.yaml`](rubrics/backend-v1.yaml): Backend 영역
- [`spring-backend-v1.yaml`](rubrics/spring-backend-v1.yaml): Spring Backend gate
- [`python-backend-v1.yaml`](rubrics/python-backend-v1.yaml): Python Backend gate
- [`node-backend-v1.yaml`](rubrics/node-backend-v1.yaml): Node.js Backend gate

각 category는 근거와 이유를 포함해 `N/A`가 될 수 있습니다. Area/profile별 applicable category만 분모에 포함해 100점으로 정규화합니다. 테스트 개수, framework 선택, 기술 개수 또는 README keyword는 직접 점수가 되지 않습니다.

## 사용 방법

현재 RepoProof는 독립 실행형 분석 CLI가 아니라 agent-driven 검증 프로젝트입니다. Shell script는 분석 대상을 안전하게 준비하고, Codex agent가 `AGENTS.md`, skills, orchestration 문서에 따라 실제 검증과 report 생성을 수행합니다.

### Repository Audit

RepoProof 루트에서 GitHub 저장소를 준비합니다.

```sh
./scripts/audit-target.sh https://github.com/OWNER/REPOSITORY.git
```

이 명령은 다음 작업만 수행합니다.

- GitHub HTTPS URL 검증
- `workspaces/<owner>-<repository>/`에 clone
- `reports/<repository>/` 준비
- Git hook과 submodule 자동 실행 방지

Dependency 설치, build, test, container 시작 또는 대상 코드는 실행하지 않습니다.

준비가 끝나면 Codex에 다음과 같이 요청합니다.

```text
https://github.com/OWNER/REPOSITORY.git 을 Repository Audit 모드로 분석해줘.
AGENTS.md와 docs/orchestration.md를 따르고 최종 report를 생성해줘.
```

같은 workspace가 이미 존재하면 덮어쓰지 않고 중단합니다. 같은 저장소를 다시 준비하려면 기존 workspace를 의도적으로 이동하거나 제거해야 합니다.

### Change Review

준비된 workspace와 비교 범위를 전달합니다.

```text
workspaces/OWNER-REPOSITORY를 RepoProof Change Review 해줘.
Base: main
Head: feature/payment
일반 PR 버그가 아니라 새로 발생하거나 악화된 engineering decision을 검증해줘.
```

Branch 대신 commit SHA를 사용할 수 있습니다. Change Review는 base, head, merge base, diff, 변경 파일과 변경 전 capability를 먼저 기록합니다.

### Fixture Regression

저장된 모든 fixture 계약을 실행합니다.

```sh
./scripts/run-fixtures.sh
```

새롭게 생성한 결과를 비교하려면 다음을 실행합니다.

```sh
./scripts/run-fixtures.sh --results <results-directory>
```

결과 디렉터리는 `<fixture-name>/regression.yaml` 구조여야 합니다. Harness는 must-find, must-not-find, profile, category, confidence, verification level, claim status와 예상 밖 finding을 검사합니다.

## 분석 흐름

1. GitHub URL을 검증하고 대상 코드를 실행하지 않은 채 clone합니다.
2. 언어, framework, build tool, 경계, 기존 capability, claim과 Frontend/Backend/Shared 영역을 조사합니다.
3. 모든 분석 가능한 영역에 Core 검증을 수행합니다.
4. 해당 영역에만 Frontend 또는 Backend specialist와 runtime specialization을 적용합니다.
5. evidence를 모으고 동일 root cause를 하나의 finding으로 병합합니다.
6. applicability, confidence, verification level, claim status와 점수를 확정합니다.
7. 실제 존재하는 profile과 area 기준으로 report를 생성합니다.

결과는 다음 위치에 생성됩니다.

```text
reports/<repository>/
├── repository-context.json
├── summary.md
├── findings.md
├── scorecard.json
└── evidence.json
```

공식 실행 계약은 [`docs/orchestration.md`](docs/orchestration.md)에 있습니다.

## 보안 원칙

외부 저장소는 신뢰하지 않는 입력입니다. Clone은 읽기 권한일 뿐 wrapper, package lifecycle script, build plugin/task, Makefile, container, migration, test, binary 또는 application 실행 권한이 아닙니다. 먼저 텍스트로 검사하고, 명시적인 검증 가설과 안전한 격리가 있을 때만 제한적으로 실행합니다.

Build, DB, cache, container, secret 또는 환경 변수가 없어도 가능한 static verification은 계속합니다. 실행할 수 없다는 이유로 finding을 VERIFIED로 확정하지 않습니다.

## Regression과 Calibration

Fixture는 Core, Spring/Python/Node Backend, profile-routing negative control을 포함합니다. 다음 명령으로 전체 regression을 실행합니다.

```sh
./scripts/run-fixtures.sh
```

실제 저장소 calibration은 고정 commit과 사람의 finding 판정을 사용하며, 특정 점수를 정답으로 취급하지 않습니다. 자세한 내용은 [`calibration/README.md`](calibration/README.md)를 참고하세요.

## Non-goals

RepoProof는 모든 저장소에 같은 architecture를 강요하거나, abstraction과 기술의 존재에 점수를 주거나, Java 규칙을 Frontend에 적용하거나, Frontend 검증을 lint로 축소하거나, Backend systems 검증을 약화하거나, 작은 문제에 저장소 전체 재설계를 권장하지 않습니다.
