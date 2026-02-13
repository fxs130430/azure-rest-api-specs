---
name: azure-typespec-author
description: |
  Author or modify Azure TypeSpec API specifications in the azure-rest-api-specs repository.
  USE FOR: Adding new API versions (preview or stable), creating or modifying ARM resources or data-plane services, defining models/enums/unions, adding operations to resources or interfaces, updating TypeSpec definitions for Azure services, fixing TypeSpec compilation errors, converting swagger to TypeSpec.
  DO NOT USE FOR: SDK generation from TypeSpec, releasing SDK packages, single MCP tool calls that do not require multi-step workflows.
  TOOLS/COMMANDS: azsdk_typespec_generate_authoring_plan, azsdk_run_typespec_validation
---

# Azure TypeSpec Author

## MCP Tools Used

| MCP Tool | Purpose |
|----------|---------|
| `azsdk_typespec_generate_authoring_plan` | Generate a grounded authoring plan for TypeSpec changes based on user request and existing code |
| `azsdk_run_typespec_validation` | Run TypeSpec compilation and lint validation after edits |

## Operating Principles (non-negotiable)

0. **This skill is MANDATORY for ALL .tsp file edits.** Any request that results in modifying, creating, or deleting content in a `.tsp` file MUST follow this full workflow — regardless of how simple the change appears. There are no "trivial" TypeSpec edits. Even changing a single `?` (optional to required) can be a breaking change requiring versioning decorators.
1. **Do not edit any files until you have required inputs and have retrieved solution** Use the `azsdk_typespec_generate_authoring_plan` MCP tool.
2. Make **minimal, scoped edits** to satisfy the request. Avoid refactors unless explicitly asked.
3. After edits, **validate** (compile / lint / emitter checks if available) and report results.
4. Always provide **references** (titles/sections/links) from retrieved context that justify the recommended approach.

## Steps

### Step 1: Intake & Clarification (no file edits)

Follow `intake-arm.md` to gather all required inputs.

Before planning edits, ensure you have:
- **Spec root / folder** (where the TypeSpec project lives)
- **Service Type**: management-plane vs data-plane
- **Existing API versions**
- **Target API version(s)** (existing or new; preview/stable)
- **Intent**: add/modify/fix (resource, operation, model, decorator, versioning, etc.)
- **Target resource/interface/operation names** (if known)
- **Constraints**: breaking-change limits, naming/versioning rules, emitter targets, etc.

If any of the above is missing, ask **up to 6 concise questions** and stop.

### Step 2: Retrieve Solution

Invoke `azsdk_typespec_generate_authoring_plan` MCP tool:

- Use user request (verbatim) as parameter `request`
- Read the relative code (.tsp) for this request, and put it as `additionalInformation` parameter
- Use typespec project root path as `typeSpecProjectRootPath` parameter

### Step 3: Apply Changes (edits)

Only after a grounded plan is produced:

- Confirm with user if any uncertainties remain
- Make the minimal changes required in the relevant `.tsp` files
- Prefer following the official template/pattern from RETRIEVED_CONTEXT even if the repo has older patterns

### Step 4: Validate

Invoke `azsdk_run_typespec_validation` MCP tool to run validation. If validation fails, fix forward with minimal changes.

### Step 5: Summarize

Return:

- Files changed (list)
- What changed and why (brief)
- Validation results (pass/fail + key output)
- References from RETRIEVED_CONTEXT used to justify important decisions

### Step 6: Next Steps (mandatory, do NOT skip)

**You MUST complete this step before ending your turn.** Read the file `next-steps-arm.md` (using the read_file tool) and execute ALL of its instructions:

1. **Step 6.1**: Verify example folder is up-to-date and report results to the user.
2. **Step 6.2**: Check for breaking changes if a stable version was added/modified.
3. **Step 6.3**: Identify the completed case type and present the corresponding **case-specific follow-up actions** to the user (e.g., asking what features to add to a new preview version, or which preview features to promote for a new stable version).

**Do NOT summarize and end your turn without presenting the follow-up actions from `next-steps-arm.md` to the user.** The user must be given the opportunity to request additional changes.

## Related Skills

- For SDK generation from TypeSpec: `sdk-generation`
- For release readiness checks: `check-package-readiness`

## References

- `intake-arm.md` — Intake and clarification steps for ARM authoring
- `next-steps-arm.md` — Post-authoring follow-up actions and case-specific guidance
