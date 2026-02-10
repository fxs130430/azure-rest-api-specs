---
name: azure-typespec-author
description: "Use this skill when authoring or modifying Azure TypeSpec API specifications in the azure-rest-api-specs repository. Triggers for any TypeSpec related tasks, including: adding new API versions (preview or stable), creating or modifying ARM resources or data-plane services, defining models/enums/unions, adding operations to resources or interfaces, updating TypeSpec definitions for Azure services, or fixing TypeSpec compilation errors. Keywords: TypeSpec, tsp, ARM, resource-manager, data-plane, API version, preview version, stable version, Azure resource, Azure service, resource provider."
---

# Azure TypeSpec Author

## Operating Principles (non-negotiable)

0. **This skill is MANDATORY for ALL .tsp file edits.** Any request that results in modifying, creating, or deleting content in a `.tsp` file MUST follow this full workflow — regardless of how simple the change appears. There are no "trivial" TypeSpec edits. Even changing a single `?` (optional to required) can be a breaking change requiring versioning decorators.
1. **Do not edit any files until you have required inputs and have retrieved solution** Use the `azure-sdk-mcp/azsdk_typespec_generate_authoring_plan` tool.
2. Make **minimal, scoped edits** to satisfy the request. Avoid refactors unless explicitly asked.
3. After edits, **validate** (compile / lint / emitter checks if available) and report results.
4. Always provide **references** (titles/sections/links) from retrieved context that justify the recommended approach.

## Required Inputs Checklist (ask if missing)
Before planning edits, ensure you have:
- **Spec root / folder** (where the TypeSpec project lives)
- **Service Type**: management-plane vs data-plane
- **Existing API versions**
- **Target API version(s)** (existing or new; preview/stable)
- **Intent**: add/modify/fix (resource, operation, model, decorator, versioning, etc.)
- **Target resource/interface/operation names** (if known)
- **Constraints**: breaking-change limits, naming/versioning rules, emitter targets, etc.

If any of the above is missing, ask **up to 6 concise questions** and stop.

## Workflow

When encountering a TypeSpec authoring cases, follow this workflow (must follow exactly):

### Step 1 — Intake & Clarification (no file edits)
Follow  `intake-arm.md` to gather all required inputs.

### Step 2 — Retrieve Solution

Call the `azure-sdk-mcp/azsdk_typespec_generate_authoring_plan` tool:

- Use user request (verbatim) as parameter `request`
- Read the relative code (.tsp) for this request, and put it as `additionalInformation` parameter
- use typespec project root path as `typeSpecProjectRootPath` parameter

### Step 3 — Apply Changes (edits)

Only after a grounded plan is produced:

- Confirm with user if any uncertainties remain
- Make the minimal changes required in the relevant `.tsp` files
- Prefer following the official template/pattern from RETRIEVED_CONTEXT even if the repo has older patterns

### Step 4 — Validate

- Run `azure-sdk-mcp/azsdk_run_typespec_validation` tool to run validation
- If validation fails, fix forward with minimal changes

### Step 5 — Summarize

Return:

- Files changed (list)
- What changed and why (brief)
- Validation results (pass/fail + key output)
- References from RETRIEVED_CONTEXT used to justify important decisions

### Step 6 — Next Steps (mandatory, do NOT skip)

**You MUST complete this step before ending your turn.** Read the file `next-step-arm.md` (using the read_file tool) and execute ALL of its instructions:

1. **Step 6.1**: Verify compilation status and report results to the user.
2. **Step 6.2**: Check for breaking changes if a stable version was added/modified.
3. **Step 6.3**: Identify the completed case type and present the corresponding **case-specific follow-up actions** to the user (e.g., asking what features to add to a new preview version, or which preview features to promote for a new stable version).

**Do NOT summarize and end your turn without presenting the follow-up actions from `next-step-arm.md` to the user.** The user must be given the opportunity to request additional changes.

---
