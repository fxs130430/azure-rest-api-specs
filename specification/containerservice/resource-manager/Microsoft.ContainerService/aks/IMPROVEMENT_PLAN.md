# AKS TypeSpec Improvement Plan

**Date:** February 3, 2026  
**Scope:** specification/containerservice/resource-manager/Microsoft.ContainerService/aks  
**Status:** Planning Phase

## Executive Summary

This document outlines a comprehensive plan to improve the TypeSpec definitions for Azure Kubernetes Service (AKS). The primary goals are to:
- Improve file organization and maintainability
- Resolve 200+ FIXME comments
- Better co-locate models with their operations
- Ensure ARM compliance
- Improve documentation quality


## Issues Identified

### 1. File Organization - Separation of Models and Operations

**Current State:**
- **Models.tsp** - Contains all shared model definitions (~7,144 lines)
- **Individual resource files** - Each contains both the resource model and operations (e.g., AgentPool.tsp, ManagedCluster.tsp)
- **Routes.tsp** - Contains standalone operation groups

**Problems:**
- The massive `Models.tsp` file (7,144 lines) is difficult to navigate and maintain
- Models defined in `Models.tsp` are separated from the operations that use them
- Hard to understand the relationship between operations and their associated models

### 2. Excessive FIXME Comments

Found **200+ FIXME comments** across the codebase, categorized as:

#### A. Documentation Issues (~75 instances)
- Missing documentation for union/enum members
- Affected files: Models.tsp (lines 76, 429-437, 672-682, 893, 899, 1107-1109, etc.)
- Impact: Reduces API discoverability and usability

#### B. Casing Style Issues (~90 instances)
- Properties with non-standard casing (camelCase violations)
- Affected files: Models.tsp (lines 2083, 2090, 2144, 2191, 2257, 2345, etc.)
- Impact: Inconsistent naming conventions

#### C. ARM Resource Violations (~20 instances)
- Invalid envelope properties (sku, extendedLocation, identity, kind)
- arm-no-record violations
- arm-resource-provisioning-state violations
- Affected files: ManagedCluster.tsp (lines 28, 34, 40, 46), Machine.tsp (line 28)
- Impact: ARM compliance issues

#### D. Operation Response Code Issues (~10 instances)
- arm-post-operation-response-codes violations
- Affected files: ManagedCluster.tsp (lines 248, 262, 277, 290, 304), AgentPool.tsp (line 85)
- Impact: Non-standard response patterns

#### E. Other Issues (~10 instances)
- Secret property violations (Models.tsp lines 3392, 3445, 4088)
- Composition over inheritance warnings (Models.tsp lines 2312, 3475, 5351)
- utcDateTime verification needed (Models.tsp lines 4136, 5463)
- no-enum rule violations (Models.tsp line 1783)


## Detailed Solution Plan

### Phase 1: Fix Documentation Issues (75+ instances)

**Goal:** Add missing documentation for all types and members

**Priority: High** - Lowest risk, highest immediate value, no breaking changes

**Action Items:**

1. **Add missing documentation for union members**
   
   **Before:**
   ```typespec
   union ExtendedLocationTypes {
     string,
     #suppress "@azure-tools/typespec-azure-core/documentation-required" "FIXME: Update justification..."
     EdgeZone: "EdgeZone",
   }
   ```
   
   **After:**
   ```typespec
   union ExtendedLocationTypes {
     string,
     /** Edge Zone extended location type */
     EdgeZone: "EdgeZone",
   }
   ```

2. **Document all enum values systematically**
   - Review original swagger definitions for descriptions
   - Add meaningful descriptions for each value
   - Focus on user-facing documentation

**Affected Files:**
- Models.tsp (lines 76, 429-437, 672-682, 893, 899, 1107-1109, 1342-1348, 1372-1384, 1425-1435, 1540-1548, 1557-1563, 1590-1598, 1898, 2009, 3156, 3559, 3564, 4498, 4699, 4748, 4756, 5145, 5293, 5329)

**Estimated work:** ~75 documentation additions


### Phase 2: Reorganize File Structure

**Goal:** Break down Models.tsp by moving models to their corresponding operation .tsp files

**Steps:**

1. **Move Resource-Specific Models to Operation Files**
   - Models tightly coupled to a specific resource should be moved to that resource's file
   - Example: `ManagedClusterAgentPoolProfileProperties` → AgentPool.tsp
   - Example: `ManagedClusterProperties` → ManagedCluster.tsp
   - Example: `SnapshotProperties` → Snapshot.tsp
   - Example: Network-related models for LoadBalancer → LoadBalancer.tsp

2. **Create CommonModels.tsp for Shared Models**
   
   Only models referenced by **multiple** operation .tsp files should go here:
   
   - **`CommonModels.tsp`** - Shared base models and types
     - Common enums/unions used across multiple resources
     - Base property types referenced by multiple resources
     - Shared response/error types

3. **Update Imports**
   - Update main.tsp to import the new organized files
   - Ensure circular dependency issues are avoided
   - Each operation .tsp imports CommonModels.tsp as needed

**Benefits:**
- Co-location of related definitions (models next to their operations)
- Reduced Models.tsp file size
- Easier navigation - find a model in the same file as its operation
- Simpler structure with only one shared file

**Files to Create:**
```
aks/
├── CommonModels.tsp           (NEW - shared models only)
├── Models.tsp                 (REMOVE or significantly reduced)
├── AgentPool.tsp              (MODIFIED - add AgentPool-specific models)
├── ManagedCluster.tsp         (MODIFIED - add ManagedCluster-specific models)
├── Snapshot.tsp               (MODIFIED - add Snapshot-specific models)
├── LoadBalancer.tsp           (MODIFIED - add LoadBalancer-specific models)
└── ... (other operation files similarly modified)
```


### Phase 3: Fix Remaining FIXME Comments (Grouped by Type)

#### 3A. Update Casing Style Suppression Justifications (90+ instances)

**Priority: Low** - These are cosmetic and cannot be fixed without breaking changes

**Reality Check:**
- Property names like `enableVnetIntegration` determine the **JSON wire format**
- Changing them would be a **breaking change** for all API consumers
- `@clientName` only affects SDK naming, NOT the wire format - linter still complains
- **Only viable option:** Keep suppressions with proper justification

**Action:** Update all FIXME suppressions with backward-compatibility justification

**Before:**
```typespec
#suppress "@azure-tools/typespec-azure-core/casing-style" "FIXME: Update justification..."
enableVnetIntegration?: boolean;
```

**After:**
```typespec
#suppress "@azure-tools/typespec-azure-core/casing-style" "Property name maintained for backward compatibility with existing API versions"
enableVnetIntegration?: boolean;
```

**Affected Files:**
- JWTAuthenticator.tsp (lines 16, 29)
- AgentPool.tsp (line 65)
- ManagedCluster.tsp (lines 114, 167, 186, 211, 234)
- Models.tsp (lines 1947, 2083, 2090, 2144, 2191, 2257, 2345, 2373, 2383, 2393, 2409, 2497, 2503, 2551, 2566, 2577, 2583, 2599, 2609, 2666, 2795, 2838, 3010, 3086, 3108, 3150, 3257, 3274, 3281, 3288, 3404, 3632, 3637, 3706, 3827, 3833, 3839, 3845, 3883, 3895, 3908, 3925, 3930, 3937, 3942, 3948, 4054, 4064, 4070, 4076, 4082, 4094, 4110, 4147, 4153, 4159, 4165, 4176, 4182, 4188, 4194, 4200, 4206, 4212, 4218, 4224, 4230, 4236, 4242, 4248, 4254, 4260, 4267, 4272, 4283, 4289, 4346, 4354, 4435, 4606, 4612, 4623, 4630, 4647, 4668, 4688, 5180)

**Estimated work:** Batch find-and-replace (~90 instances)

#### 3B. Update ARM Resource Violation Suppressions (38+ instances)

**Priority: High** - These affect ARM compliance documentation

> **⚠️ Analysis Conclusion: Suppression Justification Updates Only**
> 
> All items in Phase 3B require only suppression justification updates. Actual code fixes would cause **breaking changes** to existing API clients. The violations exist because AKS uses custom patterns that deviate from standard ARM templates for legitimate business reasons.


**Subcategory C1: Invalid Envelope Properties** (5 instances)

**Issue:** `sku`, `extendedLocation`, `identity`, `kind`, `zones` in resource envelope  
**Files:** ManagedCluster.tsp (lines 28, 34, 40, 46), Machine.tsp (line 30)

**Can Fix?** ❌ **NO - Breaking Change**

**Analysis:** These properties are intentionally placed at the envelope level (not inside `properties`). ManagedCluster uses a custom envelope pattern rather than standard ARM TrackedResource. The API already returns these fields at the envelope level in production. Moving them to the `properties` bag would:
- Break all existing SDK clients
- Break all customer automation scripts
- Require a new API version with migration path

**Action:** Update suppressions with proper justification only.

**Example:**
```typespec
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" 
  "SKU is intentionally at envelope level for ManagedCluster. This is a published API pattern that cannot be changed without breaking existing clients."
sku?: ManagedClusterSKU;
```


**Subcategory C2: arm-no-record Violations** (16 instances)

**Issue:** Using `Record<T>` type  
**Files:** Models.tsp (lines 2025, 2136, 2142, 2257, 2340, 2667, 2673, 3414, 3421, 3602, 3770, 5566, 5818, 5824, 6081, 6873)

**Can Fix?** ❌ **NO - Legitimate Use Cases**

**Analysis:** ARM discourages `Record<T>` because it creates dynamic key-value structures that are harder to document. However, all usages in AKS are **legitimate**:

| Pattern | Example | Why It's Needed |
|---------|---------|-----------------|
| `Record<KubernetesPatchVersion>` | `patchVersions` | API returns dynamic keys like `"1.29.0"`, `"1.29.1"` - impossible to enumerate all patch versions |
| `Record<string>` | `tags` | Standard ARM tags pattern with arbitrary user-defined keys |
| `Record<ManagedClusterAddonProfile>` | `addonProfiles` | Addon names are dynamic (`"omsagent"`, `"azurepolicy"`, etc.) |
| `Record<UserAssignedIdentity>` | `identityProfile` | Identity resource IDs as keys |
| `Record<DelegatedResource>` | `delegatedResources` | Delegated identity mappings |

These represent genuinely dynamic structures where keys cannot be pre-defined.

**Action:** Update suppressions with justification explaining the dynamic nature.

**Example:**
```typespec
#suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" 
  "patchVersions uses Record<> because Kubernetes patch version strings (e.g., '1.29.0', '1.29.1') are dynamic and cannot be enumerated as fixed properties"
patchVersions?: Record<KubernetesPatchVersion>;
```


**Subcategory C3: arm-resource-provisioning-state** (14 instances)

**Issue:** `provisioningState` defined as `string` instead of standard ARM enum  
**Files:** Models.tsp (lines 2170, 2619, 5401, 5573, 5897, 6451, 6504, 6585, 6611, 6642, 6705, 6798, 6865, 7002)

**Can Fix?** ❌ **NO - Breaking Change + Custom States**

**Analysis:** ARM expects `provisioningState` to use a standard enum like `ResourceProvisioningState` with values: `Succeeded`, `Failed`, `Canceled`, `Creating`, `Updating`, `Deleting`.

However, AKS has **custom provisioning states** that don't fit the standard pattern:
- `"Scaling"` - Cluster is scaling node pools
- `"Upgrading"` - Cluster is upgrading Kubernetes version
- `"Starting"` / `"Stopping"` - Cluster power state transitions
- `"Migrating"` - Cluster migration in progress

Changing from `string` to a fixed enum would:
- Break SDK deserialization when unknown states are returned
- Require enumerating all possible AKS-specific states (may change over time)

**Action:** Update suppressions explaining custom state requirements.

**Example:**
```typespec
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" 
  "AKS uses custom provisioning states (Scaling, Upgrading, Starting, etc.) beyond standard ARM states. Using string type for forward compatibility."
provisioningState?: string;
```


**Subcategory C4: Other ARM Violations** (3 instances)

| Violation | File | Can Fix? | Analysis |
|-----------|------|----------|----------|
| `arm-resource-duplicate-property` | Models.tsp line 2574 | ❌ NO | The `type` property holds `AgentPoolType` (System/User/Gateway), which is a business property. ARM resources also have `type` in their envelope (resource type). This naming collision is intentional and cannot be renamed without breaking clients. |
| `no-resource-delete-operation` | Machine.tsp line 33 | ⚠️ MAYBE | Machine resources don't expose DELETE because machines are managed internally by AKS (deleted when node pool scales down). Adding DELETE would be a **new feature**, not a fix. Requires service team decision. |
| `patch-envelope` | Models.tsp line 5561 | ❌ NO | `TagsObject` is used for PATCH tag operations. It's a standard pattern for partial updates and cannot be changed. |

**Action:** Update suppressions with justifications.

**Examples:**
```typespec
// arm-resource-duplicate-property
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-duplicate-property" 
  "The 'type' property represents AgentPoolType (System/User/Gateway), a business concept distinct from ARM resource type. Renaming would break existing clients."
type?: AgentPoolType;

// no-resource-delete-operation
#suppress "@azure-tools/typespec-azure-resource-manager/no-resource-delete-operation" 
  "Machine resources are managed internally by AKS and deleted automatically when node pools scale down. Direct DELETE is intentionally not exposed."

// patch-envelope
#suppress "@azure-tools/typespec-azure-resource-manager/patch-envelope" 
  "TagsObject is a standard ARM pattern for PATCH operations to update resource tags independently."
```


**Summary Table:**

| Subcategory | Count | Can Fix? | Action |
|-------------|-------|----------|--------|
| C1: Invalid Envelope | 5 | ❌ No | Update justifications |
| C2: arm-no-record | 16 | ❌ No | Update justifications |
| C3: provisioning-state | 14 | ❌ No | Update justifications |
| C4: Other | 3 | ❌ No (1 maybe) | Update justifications |

**Estimated work:** ~38 suppressions to update with proper justifications (batch find-and-replace)

#### 3C. Fix Operation Response Codes (10+ instances)

**Priority: Medium**

**Issue:** POST operations not returning standard response codes  
**Files:** 
- ManagedCluster.tsp (lines 248, 262, 277, 290, 304)
- AgentPool.tsp (line 85)

**Action:**

1. Review each operation's actual behavior
2. Update suppressions with proper justification based on service contract

**Example:**

**Before:**
```typespec
#suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" "FIXME: Update justification..."
@action("stop")
stop is ArmResourceActionAsync<...>;
```

**After:**
```typespec
#suppress "@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes" 
  "This operation returns 202 for async operations, which is the correct behavior for this long-running cluster stop action"
@action("stop")
stop is ArmResourceActionAsync<...>;
```

**Estimated work:** ~10 operations to review

#### 3D. Fix Miscellaneous Issues (10+ instances)

**1. Secret Property Violations**
- **Files:** Models.tsp (lines 3392, 3445, 4088)
- **Action:** Add `@secret` decorator or justify why it's not sensitive

**2. Composition vs Inheritance**
- **Files:** Models.tsp (lines 2312, 3475, 5351)
- **Action:** Review inheritance patterns and consider using composition

**3. utcDateTime Verification**
- **Files:** Models.tsp (lines 4136, 5463)
- **Action:** Verify if `utcDateTime` is the correct type or should be `plainDate`, `plainTime`, etc.
- **Note:** Remove FIXME comment after verification

**4. No Enum Rule**
- **Files:** Models.tsp (line 1783)
- **Action:** Convert `enum` to `union` per Azure guidelines

**5. Other Suppressions:**
- no-legacy-usage (ManagedNamespace.tsp line 15)
- lro-location-header (AgentPool.tsp line 122)
- arm-delete-operation-response-codes (PrivateEndpointConnection.tsp line 42)
- arm-resource-interface-requires-decorator (Routes.tsp lines 13, 30)
- no-openapi (Models.tsp line 4324)
- no-empty-model (Models.tsp line 3474)

**Estimated work:** ~15 individual issues


### Phase 4: Consolidate Related Definitions

**Goal:** Move operations and their specific models closer together

**Example Refactoring for AgentPool.tsp:**

**Current structure:**
```
Models.tsp contains: ManagedClusterAgentPoolProfileProperties
AgentPool.tsp contains: AgentPool model and AgentPools interface
```

**Proposed structure in AgentPool.tsp:**
```typespec
import "./CommonModels.tsp";
import "./ManagedCluster.tsp";

// Move these from Models.tsp to AgentPool.tsp:
model ManagedClusterAgentPoolProfileProperties {
  // ... properties
}

model AgentPool is ProxyResource<ManagedClusterAgentPoolProfileProperties> {
  // ... 
}

interface AgentPools {
  // ... operations
}
```

**Apply to all resource files:**
- ManagedCluster.tsp
- AgentPool.tsp
- MaintenanceConfiguration.tsp
- PrivateEndpointConnection.tsp
- Snapshot.tsp
- ManagedClusterSnapshot.tsp
- TrustedAccessRoleBinding.tsp
- LoadBalancer.tsp
- IdentityBinding.tsp
- JWTAuthenticator.tsp
- MeshMembership.tsp
- Machine.tsp
- ManagedNamespace.tsp
- GuardrailsAvailableVersion.tsp
- SafeguardsAvailableVersion.tsp
- MeshRevisionProfile.tsp
- MeshUpgradeProfile.tsp
- AgentPoolUpgradeProfile.tsp
- ManagedClusterUpgradeProfile.tsp


## Execution Strategy

### Core Principles

1. **No Swagger Changes for Refactoring** - Any reorganization (file renames, model moves) must produce **identical** generated OpenAPI/Swagger output. Use `diff` to verify before committing.

2. **No Breaking Changes** - Never modify:
   - Property names (wire format)
   - Required/optional status
   - Type definitions
   - Enum/union values
   - Response structures

3. **Follow Phase Order** - Execute phases in the order defined in the Detailed Solution Plan (Phase 1 → Phase 2 → Phase 3 → Phase 4).


### Validation Workflow

Before and after each phase, run this validation:

```bash
# 1. Compile TypeSpec
tsp compile .

# 2. Generate baseline swagger (before changes)
# Save the generated swagger files for comparison

# 3. After changes, regenerate and diff
diff -r ./stable/<version>/ ./stable/<version>-backup/
diff -r ./preview/<version>/ ./preview/<version>-backup/

# 4. For refactoring phases (Phase 2, Phase 4):
#    - Diff MUST show zero differences
#    - Any difference indicates unintended change

# 5. For fix phases (Phase 1, Phase 3):
#    - Only documentation changes are allowed
#    - No structural changes to API
```


### Phase-by-Phase Execution

#### Phase 1: Fix Documentation Issues
- **Risk:** None (documentation only)
- **Swagger Impact:** None expected
- **Validation:** Compile succeeds, no swagger changes
- **Commit:** `docs: Add missing documentation for TypeSpec definitions`

#### Phase 2: Reorganize File Structure
- **Risk:** Low (if done correctly)
- **Swagger Impact:** MUST be zero
- **Validation:** 
  - `tsp compile .` succeeds
  - Generated swagger is **byte-for-byte identical** to before
- **Steps:**
  1. Create backup of generated swagger files
  2. Rename files (models.tsp → Models.tsp, etc.)
  3. Create CommonModels.tsp
  4. Move models to resource files
  5. Update imports
  6. Compile and diff swagger - must be identical
- **Commit:** `refactor: Reorganize TypeSpec files without API changes`

#### Phase 3: Fix Remaining FIXME Comments
- **3A (Casing):** Update suppression justifications only - no swagger impact
- **3B (ARM):** Update suppression justifications only - no swagger impact
- **3C (Response Codes):** Update suppression justifications only - no swagger impact
- **3D (Misc):** Evaluate each individually
- **Commit:** `fix: Update suppression justifications for ARM compliance`

#### Phase 4: Consolidate Related Definitions
- **Risk:** Low (if done correctly)
- **Swagger Impact:** MUST be zero
- **Validation:** Same as Phase 2
- **Commit:** `refactor: Co-locate models with their operations`

### Commit Guidelines

| Phase | Commit Prefix | Example |
|-------|---------------|---------|
| Phase 1 | `docs:` | `docs: Add missing documentation for union members` |
| Phase 2 | `refactor:` | `refactor: Rename models.tsp to Models.tsp` |
| Phase 3 | `fix:` | `fix: Update ARM suppression justifications` |
| Phase 4 | `refactor:` | `refactor: Move AgentPool models to AgentPool.tsp` |

Make small, atomic commits for easy rollback.


## Expected Outcomes

After completing this plan:

✅ **Zero generic FIXME comments** - All either resolved or properly justified  
✅ **Better file organization** - Related models and operations co-located  
✅ **Improved documentation** - All types and members documented  
✅ **ARM compliance** - All violations properly justified  
✅ **Maintainability** - Easier to find and update definitions  
✅ **No breaking changes** - Generated swagger remains functionally identical  

## Risk Assessment

### Safe Operations (No Swagger Impact)
- Adding/updating documentation comments
- Updating suppression justification text
- Renaming .tsp files
- Moving models between .tsp files (with correct imports)
- Adding imports

### Risky Operations (May Cause Swagger Changes)
- Changing property names → **NEVER DO**
- Changing types → **NEVER DO**
- Changing required/optional → **NEVER DO**
- Removing suppressions → **VERIFY CAREFULLY**
- Adding/removing decorators → **VERIFY CAREFULLY**

### Mitigation Strategies
1. Always diff swagger output before and after changes
2. Make small, atomic commits for easy rollback
3. Compile after every file modification
4. Keep generated swagger backup before each phase


## Success Criteria

1. **TypeSpec compiles without errors**

2. **Generated Swagger is identical** (for refactoring phases)
   - `diff` shows zero differences for Phase 2 and Phase 4

3. **All FIXME comments addressed**
   - Removed (issue resolved)
   - Updated with proper justification
   - Converted to documentation

4. **No breaking changes introduced**
   - Wire format unchanged
   - All existing API contracts preserved

5. **All suppressions have meaningful justifications**

6. **Code review approval from service team**


## Appendix: File Inventory

### Current Files (with proposed renames)
```
aks/
├── main.tsp (64 lines)                    ← hardcoded name, do not rename
├── Models.tsp (7,144 lines) ⚠️ TOO LARGE  ← rename from models.tsp
├── Routes.tsp (92 lines)                  ← rename from routes.tsp
├── client.tsp                             ← hardcoded name, do not rename
├── BackCompatible.tsp                     ← rename from back-compatible.tsp
├── AgentPool.tsp (193 lines)
├── AgentPoolUpgradeProfile.tsp
├── GuardrailsAvailableVersion.tsp
├── IdentityBinding.tsp
├── JWTAuthenticator.tsp
├── LoadBalancer.tsp
├── Machine.tsp
├── MaintenanceConfiguration.tsp
├── ManagedCluster.tsp (483 lines)
├── ManagedClusterSnapshot.tsp
├── ManagedClusterUpgradeProfile.tsp
├── ManagedNamespace.tsp
├── MeshMembership.tsp
├── MeshRevisionProfile.tsp
├── MeshUpgradeProfile.tsp
├── PrivateEndpointConnection.tsp
├── SafeguardsAvailableVersion.tsp
├── Snapshot.tsp
├── TrustedAccessRoleBinding.tsp
└── tspconfig.yaml
```

### Proposed New Files
```
aks/
├── CommonModels.tsp (NEW - shared models referenced by multiple resources)
└── ... (existing files modified to include resource-specific models)
```
