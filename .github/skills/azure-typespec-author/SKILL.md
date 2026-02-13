---
name: azure-typespec-author
description: |
  Author or modify Azure TypeSpec API specifications in the azure-rest-api-specs repository.
  USE FOR: Adding new API versions (preview or stable), adding a new api version, add a new preview version, add a new stable version, add preview api version, add stable api version, add api version for service, add version for resource manager, creating or modifying ARM resources or data-plane services, defining models/enums/unions, adding operations to resources or interfaces, updating TypeSpec definitions for Azure services, fixing TypeSpec compilation errors, converting swagger to TypeSpec, add resource type, add ARM resource, add operation to resource, modify properties, add enum, add union, add model, remove property, deprecate resource, fix tsp compile errors, versioning decorators.
  DO NOT USE FOR: SDK generation from TypeSpec, releasing SDK packages, single MCP tool calls that do not require multi-step workflows.
  TOOLS/COMMANDS: azsdk_typespec_generate_authoring_plan, azsdk_run_typespec_validation
---

# Azure TypeSpec Author

## MCP Tools

| Tool | Purpose |
|------|---------|
| `azsdk_typespec_generate_authoring_plan` | Generate a grounded authoring plan for TypeSpec changes based on user request and existing code |
| `azsdk_run_typespec_validation` | Run TypeSpec compilation and lint validation after edits |

---

## Operating Principles

> **Non-negotiable** — all principles below apply to every invocation of this skill.

1. **This skill is MANDATORY for ALL `.tsp` file edits.** Any request that modifies, creates, or deletes content in a `.tsp` file MUST follow the full workflow — regardless of how simple the change appears. There are no "trivial" TypeSpec edits. Even changing a single `?` (optional → required) can be a breaking change requiring versioning decorators.
2. **Do not edit any files until you have required inputs and have retrieved a solution.** Use the `azsdk_typespec_generate_authoring_plan` MCP tool.
3. **Make minimal, scoped edits** to satisfy the request. Avoid refactors unless explicitly asked.
4. **After edits, validate** (compile / lint / emitter checks if available) and report results.
5. **Always provide references** (titles / sections / links) from retrieved context that justify the recommended approach.

---

## Workflow Steps

> **All 6 steps are MANDATORY. Do NOT skip any step.**

| Step | Name | Tool / File | Gate |
|------|------|-------------|------|
| 1 | [Intake & Clarification](#step-1-intake--clarification) | `intake-arm.md` | All inputs collected + analysis displayed |
| 2 | [Retrieve Solution](#step-2-retrieve-solution) | `azsdk_typespec_generate_authoring_plan` | Grounded plan returned |
| 3 | [Apply Changes](#step-3-apply-changes) | Editor | User confirms uncertainties |
| 4 | [Validate](#step-4-validate) | `azsdk_run_typespec_validation` | Compilation passes |
| 5 | [Summarize](#step-5-summarize) | — | Summary displayed to user |
| 6 | [Next Steps](#step-6-next-steps) | `next-steps-arm.md` | Follow-up actions presented |

---

### Step 1: Intake & Clarification

Follow `intake-arm.md` to gather all required inputs.

> **⚠️ CRITICAL**: Step 1 includes a **mandatory sub-step (Step 1.3)** that requires you to display the **📊 TypeSpec Project Analysis** summary in the chat. You **MUST** output this analysis before proceeding. Do **NOT** skip Step 1.3 or jump ahead to Step 2 without first displaying the analysis results to the user. This is a hard requirement — no exceptions.

Do NOT proceed to Step 2 until all required inputs are collected **and** the analysis output has been displayed.

---

### Step 2: Retrieve Solution

Invoke `azsdk_typespec_generate_authoring_plan` MCP tool:

| Parameter | Value |
|-----------|-------|
| `request` | User request (verbatim) |
| `additionalInformation` | Relevant `.tsp` code read from the project |
| `typeSpecProjectRootPath` | TypeSpec project root path |

Do NOT proceed to Step 3 without a grounded plan from this tool.

---

### Step 3: Apply Changes

Only after a grounded plan is produced:

1. Confirm with user if any uncertainties remain
2. Make the minimal changes required in the relevant `.tsp` files
3. Prefer the official template/pattern from retrieved context even if the repo has older patterns

---

### Step 4: Validate

Invoke `azsdk_run_typespec_validation` MCP tool to run validation.

- If validation **passes** → proceed to Step 5
- If validation **fails** → fix forward with minimal changes and re-validate
- Do NOT skip validation even if the change appears trivial

---

### Step 5: Summarize

Return the following to the user:

| Item | Detail |
|------|--------|
| **Files changed** | List of modified files |
| **What changed** | Brief description of changes and rationale |
| **Validation results** | Pass/fail + key output |
| **References** | Titles/sections/links from retrieved context that justify decisions |

---

### Step 6: Next Steps

Read the file `next-steps-arm.md` (using the read_file tool) and execute **ALL** of its instructions.

> **Do NOT** summarize and end your turn without presenting the follow-up actions from `next-steps-arm.md` to the user. The user must be given the opportunity to request additional changes.

---

## Related Skills & References

| Resource | Purpose |
|----------|---------|
| `intake-arm.md` | Step 1 — Intake and clarification steps for ARM authoring |
| `next-steps-arm.md` | Step 6 — Post-authoring follow-up actions and case-specific guidance |
| `sdk-generation` skill | SDK generation from TypeSpec |
| `check-package-readiness` skill | Release readiness checks |
