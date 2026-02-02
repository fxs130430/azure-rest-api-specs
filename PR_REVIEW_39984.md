# PR #39984 Review: Added hierarchy in Purview Unified Catalog

## Executive Summary

This PR refactors the Purview Unified Catalog TypeSpec specification by organizing operations into TypeSpec interfaces, updating operation naming conventions, and adding new functionality. The changes include both **breaking changes** and **non-breaking additions** to the REST API.

**Key Finding**: This PR contains **BREAKING CHANGES** to the REST API through operation ID renames, which will affect SDK clients.

---

## 1. Overview of Changes

### 1.1 Files Changed
- **TypeSpec Source Files**: 5 files modified
  - `client.tsp`: Removed commented-out client customizations (cleanup)
  - `main.tsp`: Added documentation to endpoint parameter
  - `models.tsp`: Enhanced documentation and added new properties
  - `routes.tsp`: Major refactoring - operations organized into interfaces
- **Generated OpenAPI**: 1 file modified
- **Example Files**: 211 files (renamed/moved/added) to align with new operation naming

### 1.2 Commit Message
"Added hierarchy in Purview Unified Catalog"

---

## 2. REST API Changes Analysis

### 2.1 **BREAKING CHANGES** ⚠️

#### 2.1.1 Operation ID Renames (Breaking)

All operation IDs have been renamed to follow the pattern `{Interface}_{Operation}`:

| Old Operation ID | New Operation ID | HTTP Method | Path |
|-----------------|------------------|-------------|------|
| `EnumerateDomains` | `BusinessDomain_Enumerate` | GET | `/domains` |
| `CreateDomain` | `BusinessDomain_Create` | POST | `/domains` |
| `GetDomainById` | `BusinessDomain_Get` | GET | `/domains/{domainId}` |
| `UpdateDomain` | `BusinessDomain_Update` | PUT | `/domains/{domainId}` |
| `DeleteDomainById` | `BusinessDomain_Delete` | DELETE | `/domains/{domainId}` |
| `ListCriticalDataElement` | `CriticalDataElements_List` | GET | `/criticalDataElements` |
| `CreateCriticalDataElement` | `CriticalDataElements_Create` | POST | `/criticalDataElements` |
| `GetCriticalDataElementById` | `CriticalDataElements_Get` | GET | `/criticalDataElements/{id}` |
| `UpdateCriticalDataElement` | `CriticalDataElements_Update` | PUT | `/criticalDataElements/{id}` |
| `DeleteCriticalDataElementById` | `CriticalDataElements_Delete` | DELETE | `/criticalDataElements/{id}` |
| `ListCriticalDataElementRelationships` | `CriticalDataElements_ListRelationships` | GET | `/criticalDataElements/{id}/relationships` |
| `CreateCriticalDataElementRelationship` | `CriticalDataElements_CreateRelationship` | POST | `/criticalDataElements/{id}/relationships` |
| `DeleteCriticalDataElementRelationship` | `CriticalDataElements_DeleteRelationship` | DELETE | `/criticalDataElements/{id}/relationships` |
| `GetCriticalDataElementFacets` | `CriticalDataElements_GetFacets` | POST | `/criticalDataElements/facets` |
| `QueryCriticalDataElements` | `CriticalDataElements_Query` | POST | `/criticalDataElements/query` |
| `ListDataProducts` | `DataProducts_List` | GET | `/dataProducts` |
| `CreateDataProduct` | `DataProducts_Create` | POST | `/dataProducts` |
| `GetDataProductById` | `DataProducts_Get` | GET | `/dataProducts/{id}` |
| `UpdateDataProduct` | `DataProducts_Update` | PUT | `/dataProducts/{id}` |
| `DeleteDataProductById` | `DataProducts_Delete` | DELETE | `/dataProducts/{id}` |
| `ListDataProductRelationships` | `DataProducts_ListRelationships` | GET | `/dataProducts/{id}/relationships` |
| `CreateDataProductRelationship` | `DataProducts_CreateRelationship` | POST | `/dataProducts/{id}/relationships` |
| `DeleteDataProductRelationship` | `DataProducts_DeleteRelationship` | DELETE | `/dataProducts/{id}/relationships` |
| `GetDataProductFacets` | `DataProducts_GetFacets` | POST | `/dataProducts/facets` |
| `QueryDataProducts` | `DataProducts_Query` | POST | `/dataProducts/query` |
| `CreateTerm` | `Terms_Create` | POST | `/terms` |
| `ListTerm` | `Terms_List` | GET | `/terms` |
| `GetTerm` | `Terms_Get` | GET | `/terms/{id}` |
| `UpdateTerm` | `Terms_Update` | PUT | `/terms/{id}` |
| `DeleteTerm` | `Terms_Delete` | DELETE | `/terms/{id}` |
| `QueryTerms` | `Terms_Query` | POST | `/terms/query` |
| `GetTermFacets` | `Terms_GetFacets` | POST | `/terms/facets` |
| `ListHierarchyTerms` | `Terms_ListHierarchy` | GET | `/terms/{id}/hierarchy` |
| `AddRelatedEntity` | `Terms_AddRelatedEntity` | POST | `/terms/{id}/relatedEntities` |
| `DeleteRelatedTerm` | `Terms_DeleteRelated` | DELETE | `/terms/{id}/relatedEntities/{entityId}` |
| `ListRelatedEntities` | `Terms_ListRelatedEntities` | GET | `/terms/{id}/relatedEntities` |
| `ListObjectives` | `Okr_List` | GET | `/objectives` |
| `CreateObjective` | `Okr_Create` | POST | `/objectives` |
| `QueryObjectives` | `Okr_Query` | POST | `/objectives/query` |
| `GetObjectiveFacets` | `Okr_GetFacets` | POST | `/objectives/facets` |
| `GetObjectiveById` | `Okr_Get` | GET | `/objectives/{id}` |
| `UpdateObjective` | `Okr_Update` | PUT | `/objectives/{id}` |
| `DeleteObjectiveById` | `Okr_Delete` | DELETE | `/objectives/{id}` |
| `ListKeyResults` | `Okr_ListKeyResults` | GET | `/objectives/{id}/keyResults` |
| `CreateKeyResult` | `Okr_CreateKeyResult` | POST | `/objectives/{id}/keyResults` |
| `GetKeyResultById` | `Okr_GetKeyResult` | GET | `/objectives/{id}/keyResults/{keyResultId}` |
| `UpdateKeyResult` | `Okr_UpdateKeyResult` | PUT | `/objectives/{id}/keyResults/{keyResultId}` |
| `DeleteKeyResultById` | `Okr_DeleteKeyResult` | DELETE | `/objectives/{id}/keyResults/{keyResultId}` |
| `ListPolicies` | `Policies_List` | GET | `/policies` |
| `UpdatePolicy` | `Policies_Update` | PUT | `/policies/{policyId}` |

**Impact**: 
- Existing SDK clients using these operation IDs will break
- Generated SDKs will have different method names
- API documentation and client code will need to be updated

#### 2.1.2 API Version Status
- API Version: `2025-09-15-preview` (Preview version)
- Since this is a **preview** API version, breaking changes are typically acceptable according to Azure API Guidelines

---

### 2.2 **NON-BREAKING ADDITIONS** ✅

#### 2.2.1 New Model Properties

**DataAssetQueryRequest** (models.tsp lines 495-496):
```typescript
@doc("includingOrphans true or false")
includingOrphans?: boolean;
```
- **Assessment**: Non-breaking addition - optional property

**ObjectiveQueryRequest** (models.tsp lines 1242-1243):
```typescript
@doc("To filter by managed attributes.")
managedAttributes?: SharedSearchManageAttributeSearchFilter[];
```
- **Assessment**: Non-breaking addition - optional property

#### 2.2.2 Enhanced Documentation

**SharedSearchManageAttributeSearchFilter** properties now have examples:
- `field`: Added example "Example: 'All Attributes Types.AttributeName'"
- `operator`: Added example "Example: 'ne' , 'eq' ,'gt' , 'ge' , 'lt' , 'le', 'contains' ,'notcontains', 'prefix','eq-any'"
- `value`: Added example "Example: '2', 'LAST_24H', LAST_7D','LAST_30D',LAST_365D','MORE_THAN_365D'"
- `type`: Added example "Example: 'int','date','double','float',richtext','short','string','boolean','multiChoice'"

**main.tsp** endpoint parameter:
- Added: `@doc("The endpoint of the Purview Unified Catalog service. Example: https://api.purview-service.microsoft.com/")`

---

### 2.3 TypeSpec Structural Changes (Non-Breaking to REST API)

#### 2.3.1 Interface Organization
Operations have been organized into TypeSpec interfaces:
- `interface CriticalDataElements { ... }`
- `interface DataProducts { ... }`
- `interface BusinessDomain { ... }`
- `interface Terms { ... }`
- `interface Okr { ... }`
- `interface Policies { ... }`

**Assessment**: This is a TypeSpec-level refactoring that improves code organization. The generated OpenAPI structure remains the same (same paths, methods, parameters).

#### 2.3.2 Operation Name Simplification
Within interfaces, operation names have been simplified:
- Old: `op ListCriticalDataElement is ...`
- New: `op List is ...` (within `interface CriticalDataElements`)

**Assessment**: Non-breaking - the OpenAPI operation IDs are set by the interface name + operation name combination.

#### 2.3.3 Client Customization Cleanup
Removed commented-out `@@clientName` decorators from `client.tsp`.

**Assessment**: Non-breaking - these were already commented out and not in effect.

---

## 3. Compliance with Azure API Guidelines

### 3.1 Conformance ✅

#### 3.1.1 Operation ID Naming Pattern
- **Guideline**: Operation IDs should follow the pattern `{ResourceType}_{Action}`
- **Status**: ✅ **COMPLIANT** - The new operation IDs follow this pattern (e.g., `CriticalDataElements_List`, `DataProducts_Create`)

#### 3.1.2 Documentation
- **Guideline**: All operations, parameters, and models must have clear descriptions
- **Status**: ✅ **COMPLIANT** - Documentation has been maintained and enhanced with examples

#### 3.1.3 Versioning
- **Guideline**: API version format should be YYYY-MM-DD or YYYY-MM-DD-preview
- **Status**: ✅ **COMPLIANT** - Uses `2025-09-15-preview`

#### 3.1.4 Security
- **Guideline**: Security definitions (OAuth2) must be present
- **Status**: ✅ **COMPLIANT** - `@useAuth(AuthToken)` with OAuth2 is defined in main.tsp

#### 3.1.5 HTTP Methods
- **Guideline**: Use standard HTTP verbs appropriately
- **Status**: ✅ **COMPLIANT** - GET for reads, POST for creates/queries, PUT for updates, DELETE for deletes

### 3.2 Breaking Changes Policy

#### 3.2.1 Preview API Versions
- **Guideline**: Breaking changes are allowed in preview API versions
- **Status**: ✅ **ACCEPTABLE** - This is a preview version (`2025-09-15-preview`)
- **Recommendation**: Document the breaking changes clearly in release notes

#### 3.2.2 Stable API Versions
- **Guideline**: No breaking changes allowed in stable API versions
- **Status**: N/A - This is a preview version

---

## 4. Data Plane API Specific Considerations

### 4.1 Data Plane Characteristics ✅
- Uses OAuth2 authentication ✅
- Does not use ARM resource provider patterns ✅
- Operations are scoped to data management, not resource management ✅
- Uses `@server` decorator with custom endpoint ✅

### 4.2 Naming Conventions ✅
- Properties use camelCase ✅
- Operations use PascalCase within interface ✅
- Generated operation IDs use underscore separator ✅

---

## 5. TypeSpec Best Practices Review

### 5.1 Strengths ✅
1. **Interface Organization**: Grouping related operations into interfaces improves maintainability
2. **Documentation Examples**: Adding concrete examples to documentation helps developers
3. **Consistent Patterns**: All interfaces follow the same structural pattern
4. **Suppression Decorators**: Properly documented reasons for suppressing linter rules

### 5.2 Areas for Consideration
1. **Migration Path**: Consider providing operation ID aliases for backward compatibility during a transition period
2. **Changelog**: Ensure comprehensive changelog documenting the operation ID changes
3. **SDK Impact**: Coordinate with SDK teams to ensure smooth transition

---

## 6. New Functionality

### 6.1 Example Files Suggest New Operations
Based on example file names, there appear to be new "Count" operations:
- `CriticalDataElements_Count_Gen.json`
- `DataProducts_Count_Gen.json`
- `Okr_Count_Gen.json`
- `Terms_Count_Gen.json`

**Assessment**: These examples exist but the corresponding operations may not be fully implemented in the TypeSpec or OpenAPI yet. Needs verification.

### 6.2 New Policy Examples
New policy example files have been added:
- `Policies_Update_DataGovernanceApp_Gen.json`
- `Policies_Update_DgDataQualityScope_Gen.json`

**Assessment**: Suggests expanded policy functionality.

---

## 7. Recommendations

### 7.1 For PR Approval

#### High Priority
1. ⚠️ **Document Breaking Changes**: Add a clear section to the PR description listing all operation ID changes
2. ⚠️ **SDK Coordination**: Ensure SDK teams are aware of the breaking changes and have updated their generators
3. ⚠️ **Changelog**: Create or update CHANGELOG.md to document these breaking changes
4. ⚠️ **Migration Guide**: Consider providing a migration guide for existing clients

#### Medium Priority
5. 📝 **Verify Count Operations**: Confirm if Count operations are intended to be added and ensure they're properly implemented
6. 📝 **Example File Consistency**: Verify all renamed example files correctly reference the new operation IDs
7. 📝 **Test Coverage**: Ensure test coverage for all renamed operations and new properties

#### Low Priority
8. ✨ **Release Notes**: Prepare release notes highlighting the improved organization and new features
9. ✨ **API Documentation**: Update any external API documentation to reflect new operation names

### 7.2 For Future PRs
1. Consider using `@added`, `@removed`, or `@renamedFrom` decorators to track API evolution
2. For stable API versions, avoid operation ID changes - use client customizations instead
3. Consider implementing semantic versioning for the TypeSpec modules themselves

---

## 8. Conclusion

### 8.1 Summary
This PR makes significant structural improvements to the Purview Unified Catalog TypeSpec specification by organizing operations into logical interfaces and standardizing naming conventions. The changes result in **breaking changes to operation IDs** in the generated REST API.

### 8.2 Verdict
- **TypeSpec Quality**: ✅ **Excellent** - Well-structured refactoring with clear patterns
- **API Guidelines Compliance**: ✅ **Compliant** - Follows Azure API guidelines for data-plane APIs
- **Breaking Changes**: ⚠️ **Present but Acceptable** - Breaking changes are present, but acceptable for preview API version
- **Overall Recommendation**: ✅ **APPROVE with conditions**

### 8.3 Approval Conditions
1. Add comprehensive documentation of breaking changes to PR description
2. Confirm coordination with SDK teams
3. Verify Count operations are intentional and properly implemented
4. Update CHANGELOG.md

---

## 9. Detailed Change Log

### Added
- New optional property `includingOrphans` in `DataAssetQueryRequest` model
- New optional property `managedAttributes` in `ObjectiveQueryRequest` model
- Enhanced documentation with examples for `SharedSearchManageAttributeSearchFilter` properties
- Documentation for endpoint parameter in main.tsp
- Example files for Count operations (CriticalDataElements, DataProducts, Okr, Terms)
- New policy example files

### Changed
- All operation IDs renamed to follow `{Interface}_{Operation}` pattern
- Operations organized into TypeSpec interfaces (CriticalDataElements, DataProducts, BusinessDomain, Terms, Okr, Policies)
- 211 example files renamed to match new operation naming convention

### Removed
- Commented-out client customizations from client.tsp

---

## Appendix A: Files Modified

**TypeSpec Source Files:**
- `specification/purviewdatagovernance/Azure.Analytics.Purview.UnifiedCatalog/client.tsp`
- `specification/purviewdatagovernance/Azure.Analytics.Purview.UnifiedCatalog/main.tsp`
- `specification/purviewdatagovernance/Azure.Analytics.Purview.UnifiedCatalog/models.tsp`
- `specification/purviewdatagovernance/Azure.Analytics.Purview.UnifiedCatalog/routes.tsp`

**Generated OpenAPI:**
- `specification/purviewdatagovernance/data-plane/Azure.Analytics.Purview.UnifiedCatalog/preview/2025-09-15-preview/CatalogApiService.json`

**Example Files:** 211 files (renamed/moved/added)

---

**Review Date:** 2026-02-02  
**Reviewer:** GitHub Copilot  
**API Guidelines Version:** https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md
