# AGENT_CONTROL_LGX_PREVIEW.md – LonGenix-Prime Preview Guardrails

This document defines how any engineering agent must operate on the LonGenix-Prime codebase when working in Cloudflare Pages Preview.

The purpose is to keep all automated changes safe, scoped, and reversible, and to avoid any accidental impact on production.

---

## 1. Environment & Scope

**You operate only in Preview.**

**DRY_RUN=true in preview:**
- No DB writes.
- No persistent side effects.

**Access:**
- Basic Auth credentials in the form `preview:<PW>`.
- Tenants are limited to: `demo-a`, `demo-b`, `demo-c`.
- Exact preview URLs and passwords are provided out-of-band (e.g. locally in `LGX-Agent-Log.txt`).  
  **They must never be committed to the repository.**

---

## 2. Hard Guardrails (Non-Negotiable)

Any engineering agent must obey all of the following:

### Do NOT touch production:
- Do not modify production branches.
- Do not modify production configuration.
- Do not read, write, or rotate production secrets.

### Do NOT force-push.

### Do NOT change secrets or environment variables.
- No creating, editing, or deleting secrets.
- No changing CI/CD variables.

### Do NOT merge PRs.
- You may open PRs, but **never merge them**.
- The human operator is responsible for review and merge decisions.

**If you are ever unsure whether an action might affect production, stop and report instead of proceeding.**

---

## 3. Base Branch and Naming

The base preview working branch is:  
**`feat/my-first-mods-preview`**

For each task, create a short-lived branch from that base using the pattern:  
**`fix/preview-<topic>`**

**Examples:**
- `fix/preview-dynamic-ldl`
- `fix/preview-agent-control-doc`
- `fix/preview-hba1c-card`

**Do not reuse branches across unrelated tasks.**

---

## 4. Task Pattern for Each `<topic>`

For every change related to a `<topic>`, follow this pattern:

### 4.1 Scope

- Modify only the minimal files needed to implement the requested behavior.
- Do not refactor unrelated code or perform "cleanup" outside the scope of the task.
- Do not change infrastructure, CI/CD configuration, or secrets.

### 4.2 Feature Flag

Introduce a preview-only feature flag for each topic:  
**`PREVIEW_<TOPIC>=true`**

- Gate all new behavior behind this flag.
- If the flag is disabled, the application should behave as it did before the change (for that topic).

### 4.3 Dynamic and Data-Gated Logic

Replace static "one-size-fits-all" content with dynamic, data-driven behavior.

**Gating rules:**
- If required data is missing or invalid, **hide the block**.
- Set `shown=false` or omit the card rather than guessing.

All recommendations must be based on available:
- Labs / biomarkers
- Calculated risks
- Medications
- Preferences
- Contraindications

**Do not fabricate data or recommendations.**

### 4.4 Preview Probe Endpoint

For each topic, create a small, non-persistent probe endpoint:

```
POST /api/report/preview/<topic>
```

**Requirements:**
- Reuse the same helpers or logic paths as the main `/report` endpoint where possible.
- Accept JSON input only.
- Return JSON only (you may include a small `html` snippet if the design requires).
- **No DB writes, no persistent storage, and no side effects.**

Return a stable shape, for example:

```json
{
  "success": true,
  "shown": true,
  "<topicSpecificField1>": 123,
  "<topicSpecificField2>": "value",
  "html": "<p>optional snippet</p>"
}
```

### 4.5 Testing Documentation

For each topic, add a markdown file:

```
TESTING_<TOPIC>.md
```

The testing doc must include:

- 3–4 test scenarios (including negative / missing-data cases).
- PowerShell examples using `Invoke-RestMethod`.
- curl examples.
- **Required headers:**
  - `Authorization: Basic <base64("preview:<PW>")>`
  - `X-Tenant-ID: demo-a` (or another demo tenant)
  - `Content-Type: application/json`
- Expected behavior for each scenario.

**Use placeholders such as `<PW>` and `<BASE>` in documentation.  
Never commit real passwords or tokens.**

### 4.6 Pull Request Requirements

- Open a PR from `fix/preview-<topic>` to `feat/my-first-mods-preview`.
- **Do NOT merge the PR.**

In the PR description include:
- A one-paragraph summary of the change.
- A brief list of modified files and why.
- Step-by-step verification instructions (which curl and PowerShell commands to run, and expected outputs).
- A reminder that all changes are preview-only and must be reviewed by a human before merging.

---

## 5. Behavior on Errors or Mismatches

If you encounter any of the following:
- Repository mismatch (missing branch, unexpected layout).
- Authentication failures (401, 403).
- Missing environment variables.
- Cloudflare, CI/CD, or other infrastructure errors.

**You must:**

1. **Stop immediately.**  
   Do not try to fix infrastructure or change secrets.

2. **Collect:**
   - The exact command or API call you ran.
   - The full error message and status code.

3. **Report these details** in your response or in the PR description.

**Do not:**
- Create or rotate secrets.
- Modify CI pipelines.
- Change DNS, Pages project settings, or other infrastructure.

---

## 6. Example: LDL Preview Probe (Reference Only)

The LDL preview work is an example of how these rules apply.

**Endpoint:** `POST /api/report/preview/ldl`

**Scope:** preview-only LDL block logic.

**Behavior:**
- `{}` → `success=true`, `shown=false` (no data, card hidden).
- `{"biomarkers":{"ldl":145}}` → `shown=true`, `ldlTarget=130`.
- `{"biomarkers":{"ldl":95},"risk":{"ascvd":0.09}}` → `shown=true`, `ldlTarget=100`.
- `{"biomarkers":{"ldl":95},"risk":{"ascvd":0.25}}` → `shown=true`, `ldlTarget=70`.

**Tests documented in:** `TESTING_LDL.md`.

Future topics (e.g. HbA1c, blood pressure, sleep, TCM-specific patterns) should follow the same pattern:
- Preview-only feature flag.
- Data-gated, dynamic logic.
- Probe endpoint under `/api/report/preview/<topic>`.
- `TESTING_<TOPIC>.md` with PowerShell + curl examples.
- PR back to `feat/my-first-mods-preview`, not merged.
