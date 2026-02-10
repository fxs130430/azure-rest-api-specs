# TypeSpec ARM Authoring - Next Steps

This skill focuses on Step 6: Follow-up Actions that occur after TypeSpec ARM authoring tasks are complete. It determines next steps and provides guidance through related changes.

**After completing any TypeSpec authoring case, ALWAYS perform these checks:**

### Step 6.1: Verify Example folder is update-to-date
```
verify that examples are correctly updated or added:

1. Check that all example files under the `examples/` folder are present and consistent with the current API version and operations.
2. If examples are missing, outdated, or incorrect, **repeat from Step 1** — retrieve a new authoring plan specifically to update/add the examples for this version.
```

---

### Step 6.2: Check for Breaking Changes 

**Goal**: If a new feature was added to a stable API version, warn and let user confirm.

**Actions**:

1. Compare the current changes against the previous stable version
2. Identify any of the following breaking change categories:
   - Removed or renamed properties
   - Changed property types or formats
   - Changed required/optional status of properties
   - Removed or renamed resources or operations
   - Changed response codes or response schemas
   - Removed enum/union members
3. List all detected breaking changes

**Output (breaking changes found)**:

```
⚠️ Breaking Change Review (Stable Version)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The following potential breaking changes were detected:

1. [Description of breaking change]
   - File: [file]
   - Impact: [what clients/SDKs may be affected]

2. [Description of breaking change]
   - File: [file]
   - Impact: [what clients/SDKs may be affected]

⚠ Breaking changes in stable versions require careful consideration.
  Please review and confirm these are intentional.
```

**Output (no breaking changes)**:

```
✅ No breaking changes detected for stable version [version].
```

---

### Step 6.3: Identify Related Actions

**Goal**: Determine what additional changes might be needed

**Actions**:

After completing Step 6.1, check whether the completed case falls into one of the supported cases below:

```
🔧 Supported Cases for Follow-up
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Add New Preview Version
2. Add New Stable Version
```

**Routing Logic**:

- **If the completed case matches a supported case**: Proceed to the corresponding **Case-Specific Follow-up Actions** section below to present targeted follow-up options.
- **If the completed case does NOT match any supported case**: Skip case-specific follow-up actions. Simply confirm completion and ask the user if they have any additional requests.

**Output (matched case)**:

```
📌 Follow-up actions available for: [Case Name]
   Presenting case-specific next steps...
```

**Output (no matching case)**:

```
✅ Changes have been applied and validated successfully.

Do you have any additional requests, or are you done?
```

---

## Case-Specific Follow-up Actions

Based on the completed case, present targeted follow-up questions. **Only present these if the completed case matched a supported case in Step 6.3.**

---

### Case 1: Add New Preview Version

**Completed**: Added version [version] to Versions enum

**Follow-up Question**:

```
✅ Preview version [version] has been added successfully.

What would you like to add to this preview version? For example:
- "Add Widget resource with CRUD operations"
- "Add restart action to Employee resource"
- "Add email property to EmployeeProperties"
- "Add EmployeeStatus enum"
- "Add nested Certificate resource under Employee"
- "Mark city property as removed"

Type your request, or "done" if no additional changes needed:
```



---

### Case 2: Add New Stable Version

**Completed**: Added stable version [version] to Versions enum


**Follow-up Question**:

```
✅ Stable version [version] has been added successfully.

**First, I'll review the latest preview version features and list them for your confirmation.**

Available preview features to promote:
- [List of features from latest preview version]

Would you like to carry forward ALL of these features to stable version [version]?
- Type "yes" to promote all features
- Or specify which features to EXCLUDE: "all except [feature name]" or "only [feature name]"


What would you like to add to this preview version? For example:
- "Add Widget resource with CRUD operations"
- "Add restart action to Employee resource"
- "Add email property to EmployeeProperties"
- "Add EmployeeStatus enum"
- "Add nested Certificate resource under Employee"


Type your request, or "done" if no additional changes needed:
```



---
