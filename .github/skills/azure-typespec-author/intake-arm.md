# TypeSpec ARM Authoring - Intake and Clarification

This document focuses on Step 1: Intake and Clarification for TypeSpec ARM authoring workflows. It collects all necessary information before moving forward with implementation.

## Universal Intake Requirement (All Cases)

**Before asking any case-specific questions, ALWAYS complete these steps:**

### Step 1.1: Analyze the Codebase

**Goal**: Understand the current TypeSpec project structure and gather all required inputs.

#### Required Inputs Checklist (ask if missing)

Before planning edits, ensure you have:
- **Spec root / folder** (where the TypeSpec project lives)
- **Service Type**: management-plane vs data-plane
- **Existing API versions**
- **Target API version(s)** (existing or new; preview/stable)
- **Intent**: add/modify/fix (resource, operation, model, decorator, versioning, etc.)
- **Target resource/interface/operation names** (if known)
- **Constraints**: breaking-change limits, naming/versioning rules, emitter targets, etc.

If any of the above is missing, ask **up to 6 concise questions** and stop.

#### Actions

1. Locate the TypeSpec project files (main.tsp, tspconfig.yaml)
2. Read and parse the main.tsp file to identify:
   - Service namespace
   - Versions enum and all API versions
   - Existing resources and their operations
   - Existing models, enums, and unions
3. Determine the project structure and file organization

#### Output

Display analysis results:

```
📊 TypeSpec Project Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Namespace: Microsoft.ServiceName
Project Path: /path/to/tspconfig.yaml

API Versions:
  ✓ 2024-01-01 (stable)
  ✓ 2024-06-01-preview (preview)

Latest Version: 2024-06-01-preview (preview)

Existing Resources:
  • ResourceType1
  • ResourceType2

Existing Models: [count]
Existing Enums: [count]
```

---

**Goal**: Determine the latest version in the project and clarify which version you're working with

**Definitions**:
- **Latest Version**: The most recent version currently defined in the Versions enum (may be preview or stable)
- **Current Working Version**: The version you want to add or modify in this session

**Actions**:

1. Check the Versions enum to identify the latest version string
2. Determine if the latest version contains "-preview" suffix
3. Note: Your current working version may differ from the latest version depending on your use case

**Output**:

```
🔍 Version Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Latest Version in Enum: 2024-06-01-preview
Type: PREVIEW

Latest Version Characteristics:
• Breaking changes are allowed
• Can add/modify features freely
• Target for new development

Current Working Version: [To be determined based on your use case]
```

**Next**: Based on whether you're adding a new preview, promoting to stable, or modifying the latest version, the current working version will be clarified in Step 1.3.

---

## Step 1.3: Identify Supported Case

**Goal**: Determine which authoring case the user needs

**Actions**:

After completing Steps 1.1 and 1.2, check whether the user's request falls into one of the supported cases below:

```
🔧 Supported Cases
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Add New Preview Version
   → Add a new preview API version to the Versions enum

2. Add New Stable Version
   → Promote to a new stable API version

3. Add New Resource Type
   → Define a new ARM resource with operations
```

**Routing Logic**:

- **If the user's request matches a supported case**: Identify the matching case, and proceed to the corresponding **Case-Specific Intake Questions** section below to gather additional inputs.
- **If the user's request does NOT match any supported case**: Skip case-specific intake questions entirely. Proceed directly to **Step 2: Retrieve Solution** using the information already collected from Steps 1.1 and 1.2, along with the user's original request.

**Output (matched case)**:

```
📌 Selected Case: [Case Name]
   Proceeding with case-specific questions...
```

**Output (no matching case)**:

```
📌 No matching supported case identified.
   Proceeding directly to Step 2 with the information collected so far.
```

---

## Case-Specific Intake Questions

After completing Steps 1.1–1.3, proceed with questions for the selected case. **Only ask these questions if the user's request matched a supported case in Step 1.3.**

---

### Case 1: Add New Preview Version

**Context from Analysis**: Latest version is [version] ([preview/stable])

**Additional Questions to Ask**:

```
1. What is the new preview version you want to add?
   Format: YYYY-MM-DD-preview
   Example: 2025-03-01-preview

2. What is the latest version type in your project?
   □ Preview (e.g., 2024-06-01-preview)
   □ Stable (e.g., 2024-06-01)
```

**Validation**:

- Version format: YYYY-MM-DD-preview
- Date is not in the past
- Version doesn't already exist in versions enum

**Information Collected**:

```json
{
  "case": "add-new-preview-version",
  "namespace": "[from analysis]",
  "projectPath": "[from analysis]",
  "currentLatestVersion": "[from analysis]",
  "newVersion": "[user input]"
}
```


---

### Case 2: Add New Stable Version

**Context from Analysis**: Latest version is [version] ([preview/stable])

**Additional Questions to Ask**:

```
1. What is the new stable version you want to add?
   Format: YYYY-MM-DD
   Example: 2025-06-01

2. Are there any breaking changes from the latest preview that should NOT
   be carried into stable?
   □ No, promote all preview changes to stable
   □ Yes (specify which features/properties to exclude)

```

**Validation**:

- Version format: YYYY-MM-DD (no "-preview" suffix)
- Date is not in the past
- Version doesn't already exist in versions enum
- A preview version should exist before promoting to stable

**Information Collected**:

```json
{
  "case": "add-new-stable-version",
  "namespace": "[from analysis]",
  "projectPath": "[from analysis]",
  "currentLatestVersion": "[from analysis]",
  "newVersion": "[user input]",
  "excludeFromPromotion": []
}
```

---

### Case 3: Add New Resource Type

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Existing resources: [list]

**Additional Questions to Ask**:

```
1. Which API version(s) should include this new resource?
   □ Latest version only ([version])
   □ Multiple versions (specify)

2. What is the resource type name?
   Format: PascalCase (e.g., Widget, VirtualMachine)

3. Is this a top-level resource or nested under a parent?
   □ Top-level (e.g., /subscriptions/.../resourceGroups/.../providers/Microsoft.Service/resources/{name})
   □ Nested (e.g., /.../{parentName}/childResources/{name})

   If nested, what is the parent resource? [show existing resources]

4. What properties should this resource have?
   (Provide property name, type, required/optional, description)
```

**Validation**:

- Resource name is PascalCase
- confirm it's top-level resource or child resource
- if it is child resource, provide parent resource

**Information Collected**:

```json
{
  "case": "add-new-resource-type",
  "namespace": "[from analysis]",
  "targetVersions": ["[version]"],
  "resourceName": "[user input]",
  "isNested": true/false,
  "parentResource": "[if nested]",
  "operations": {
    "get": true,
    "put": { "enabled": true, "isLRO": false },
    "patch": false,
    "delete": { "enabled": true, "isLRO": true },
    "listBySubscription": false,
    "listByResourceGroup": true
  },
  "properties": []
}
```

---

### Case 4: Add Operation/Action to Existing Resource

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Existing resources: [list]

**Additional Questions to Ask**:

```
1. Which resource should this operation be added to?
   [show existing resources from analysis]

2. What type of operation do you want to add?
   □ Custom action (POST) — e.g., restart, start, stop, failover
   □ Custom GET action — e.g., listKeys, getStatus
   □ Standard CRUD operation not yet present (get/put/patch/delete/list)

3. What is the operation name?
   Format: camelCase (e.g., restart, listKeys, start)

4. Does this operation require a request body?
   □ No (no input parameters beyond the resource identity)
   □ Yes (describe the input properties)

5. Does this operation return a response body?
   □ No (returns 200/204 with no body)
   □ Yes, returns the resource itself
   □ Yes, returns a custom response (describe properties)

6. Is this a long-running operation (LRO)?
   □ No
   □ Yes
```

**Validation**:

- Operation name is camelCase
- Target resource exists in the project
- Operation doesn't already exist on the resource

**Information Collected**:

```json
{
  "case": "add-operation-to-resource",
  "namespace": "[from analysis]",
  "targetResource": "[user input]",
  "operationType": "action|get-action|crud",
  "operationName": "[user input]",
  "hasRequestBody": true/false,
  "requestProperties": [],
  "hasResponseBody": true/false,
  "responseType": "resource|custom|none",
  "responseProperties": [],
  "isLRO": true/false
}
```

---

### Case 5: Add/Modify Properties on Existing Resource

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Existing resources: [list]

**Additional Questions to Ask**:

```
1. Which resource should the properties be added/modified on?
   [show existing resources from analysis]

2. What properties do you want to add or modify?
   For each property, provide:
   - Property name (camelCase)
   - Type (string, int32, int64, boolean, float32, utcDateTime, url,
     or a custom model/enum name)
   - Required or optional?
   - Description
   - Is it read-only, write-only, or read-write?

   Example:
     name: displayName
     type: string
     required: optional
     description: "The display name of the resource"
     visibility: read-write

3. Should any existing properties be modified?
   □ No
   □ Yes (specify property name and what to change)
```

**Validation**:

- Property names are camelCase
- Target resource exists in the project
- Types are valid TypeSpec types or reference existing models/enums
- No duplicate property names on the same resource

**Information Collected**:

```json
{
  "case": "add-modify-properties",
  "namespace": "[from analysis]",
  "targetResource": "[user input]",
  "newProperties": [
    {
      "name": "[user input]",
      "type": "[user input]",
      "required": true/false,
      "description": "[user input]",
      "visibility": "read|write|read-write|read-only"
    }
  ],
  "modifiedProperties": []
}
```

---

### Case 6: Add New Model, Enum, or Union

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Existing models: [count]
- Existing enums: [count]

**Additional Questions to Ask**:

```
1. What type do you want to define?
   □ Model (a structured object with properties)
   □ Enum (a fixed set of known string values)
   □ Union (an extensible set of string values)

2. What is the name?
   Format: PascalCase (e.g., WidgetStatus, EncryptionConfig)

3. Provide the members/properties:

   For Model:
     - Property name, type, required/optional, description
   For Enum:
     - Value name (PascalCase) and string value
     - Example: Running = "Running", Stopped = "Stopped"
   For Union:
     - Named variant and string literal
     - Example: Running: "Running", Stopped: "Stopped"

4. Is this type used by an existing resource or operation?
   □ No (standalone, will be referenced later)
   □ Yes (specify which resource/operation property)
```

**Validation**:

- Name is PascalCase
- Name doesn't conflict with existing types
- For enums: prefer `union` over `enum` per Azure style guidelines

**Information Collected**:

```json
{
  "case": "add-model-enum-union",
  "namespace": "[from analysis]",
  "definitionType": "model|enum|union",
  "name": "[user input]",
  "members": [],
  "usedBy": "[resource/property if specified]"
}
```

---

### Case 7: Mark Property or Resource as Removed

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Existing resources: [list]

**Additional Questions to Ask**:

```
1. What do you want to mark as removed?
   □ A property on a resource
   □ An entire resource type
   □ An operation on a resource
   □ An enum/union member

2. Specify the target:
   - Resource name: [name]
   - Property/operation/member name (if applicable): [name]

3. In which version was it removed?
   □ The latest version ([version])
   □ A specific version (provide version string)
```

**Validation**:

- Target resource/property/operation exists in the project
- The item being removed was previously `@added` in an earlier version
- Latest version must be a preview version (removals not allowed directly in stable)

**Information Collected**:

```json
{
  "case": "mark-removed",
  "namespace": "[from analysis]",
  "removalTarget": "property|resource|operation|member",
  "targetResource": "[user input]",
  "targetName": "[user input]",
  "removedInVersion": "[user input or latest]"
}
```

---

### Case 8: Fix TypeSpec Compilation Errors

**Context from Analysis**:

- Latest version: [version] ([preview/stable])
- Project path: [path]

**Additional Questions to Ask**:

```
1. What error(s) are you seeing?
   □ I'll paste the error output
   □ I don't know — please run compilation and check

2. (If user pastes errors) Please provide the full error output:
   [free text input]
```

**Actions** (instead of additional questions):

- If user says "please check", run `azure-sdk-mcp/azsdk_run_typespec_validation`
- Parse the error output to identify:
  - File and line number
  - Error code (e.g., `@azure-tools/typespec-azure-resource-manager/...`)
  - Error message
- Categorize errors into: syntax, decorator usage, versioning, missing import, lint rule violation

**Information Collected**:

```json
{
  "case": "fix-compilation-errors",
  "namespace": "[from analysis]",
  "projectPath": "[from analysis]",
  "errors": [
    {
      "file": "[file]",
      "line": "[line]",
      "code": "[error code]",
      "message": "[error message]",
      "category": "syntax|decorator|versioning|import|lint"
    }
  ]
}
```

---

## Summary and Confirmation

After collecting all information, display a comprehensive summary:

```
✅ Information Collection Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Case: [Case Name]

Project Information:
  Namespace: [namespace]
  Project Path: [path]
  Current Latest Version: [version] ([preview/stable])

Requested Changes:
  [Summary of user inputs]

Target Version(s): [versions]

Ready to Proceed: YES

Is this information correct? (yes/no)
```

Wait for user confirmation before proceeding to next steps.

---

## Next Steps

Once information is confirmed:

```
✅ All required information collected.
Ready to proceed to Step 2: Retrieve Solution

Next actions:
1. Call azsdk_typespec_retrieve_solution with collected information
2. Apply recommended changes to TypeSpec files
3. Validate compilation results
```

---

## Common Validation Rules

### For All Cases

- Service namespace follows Microsoft.ServiceName pattern
- TypeSpec project path exists and contains tspconfig.yaml and main.tsp
- Target API version is valid format

### Version Format Validation

- Preview: YYYY-MM-DD-preview (e.g., 2025-03-01-preview)
- Stable: YYYY-MM-DD (e.g., 2025-03-01)
- Date must not be in the past (allow current date)

### Naming Conventions

- Resource types: PascalCase (e.g., Widget, VirtualMachine)
- Operations/Actions: camelCase (e.g., start, listByResourceGroup)
- Models/Enums/Unions: PascalCase (e.g., WidgetProperties, ProvisioningState)
- Properties: camelCase (e.g., displayName, provisioningState)

### Breaking Change Rules

- Preview versions: Breaking changes allowed
- Stable versions: Breaking changes require careful consideration and clear justification
