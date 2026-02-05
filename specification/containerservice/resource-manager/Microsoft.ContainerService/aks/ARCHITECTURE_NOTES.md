# AKS TypeSpec Architecture Notes

## Current Structure Overview

The AKS TypeSpec specification is organized into multiple files:
- **CommonModels.tsp** (~5,000 lines) - Shared models, unions, and enums
- **ManagedCluster.tsp** - ManagedCluster resource and operations
- **AgentPool.tsp** - AgentPool resource and operations (child of ManagedCluster)
- **Other resource files** - Each resource has its own .tsp file with models and operations

## Known Limitations and Dilemmas

### 1. Import Direction Constraint

**Problem:** Child resources must import their parent resource file.

```
AgentPool.tsp imports ManagedCluster.tsp
```

This is required because:
```typespec
@parentResource(ManagedCluster)  // Needs ManagedCluster type
model AgentPool is ProxyResource<...> { ... }
```

**Ideal structure:** Parent resource files should import child resources (parent "owns" children).

**Actual structure:** Child resources must import parent resources (to reference `@parentResource`).

This is a TypeSpec framework limitation - the `@parentResource` decorator requires the parent type to be in scope.

### 2. CommonModels.tsp Size (~5,000 lines)

Despite refactoring efforts, CommonModels.tsp remains large because it contains truly shared types.

#### Content Breakdown:

| Type | Count | Approx Lines |
|------|-------|--------------|
| Unions (enums) | 69 | ~1,200 |
| Models | 143 | ~3,600 |
| Enums | 1 | ~20 |
| Scalars | 2 | ~10 |

#### Model Distribution:

| Prefix | Count | Why Shared |
|--------|-------|------------|
| ManagedCluster* | 69 | Used by ManagedCluster, AgentPool, Snapshots |
| AgentPool* | 9 | Used by AgentPool and Machine resources |
| Istio* | 6 | Service mesh configuration (part of ManagedClusterProperties) |
| Container* | 6 | Container service profiles |
| Kubernetes* | 5 | Version info used by Routes and multiple resources |
| Others | ~48 | Various shared utilities |

#### Why ManagedCluster* models can't be moved to ManagedCluster.tsp:

1. **ManagedClusterAgentPoolProfileProperties** - Used by AgentPool resource
2. **ManagedClusterPropertiesForSnapshot** - Used by ManagedClusterSnapshot
3. **ManagedClusterProperties** - Contains nested types referenced elsewhere
4. Moving them would create circular imports

### 3. Operations vs Models Placement

**Principle:** Models should stay with their operations.

**Challenge:** Some operations in ManagedCluster.tsp are tagged for other domains:
```typespec
@tag("AgentPools")
getAvailableAgentPoolVersions is ArmResourceActionSync<ManagedCluster, ...>

@tag("privateLinkResources") 
privateLinkResourcesList is ArmResourceActionSync<ManagedCluster, ...>
```

These operations are actions ON ManagedCluster that RETURN AgentPool/PrivateLink data. The models stay in ManagedCluster.tsp because:
- The operations are defined in `interface ManagedClusters { ... }`
- Moving operations would break the interface structure
- Tags are for Swagger organization, not code organization

## Completed Refactoring (Phase 2)

Models successfully moved to their resource files:

| Resource File | Models Moved |
|---------------|--------------|
| Snapshot.tsp | SnapshotProperties |
| ManagedClusterSnapshot.tsp | ManagedClusterSnapshotProperties, ManagedClusterPropertiesForSnapshot, NetworkProfileForSnapshot |
| MaintenanceConfiguration.tsp | MaintenanceConfigurationProperties, TimeInWeek, Schedule, etc. |
| PrivateEndpointConnection.tsp | PrivateEndpointConnectionProperties, PrivateLinkServiceConnectionState, etc. |
| TrustedAccessRoleBinding.tsp | TrustedAccessRoleBindingProperties, TrustedAccessRole, etc. |
| LoadBalancer.tsp | LoadBalancerProperties, LabelSelector, etc. |
| Machine.tsp | MachineProperties, MachineStatus, MachineNetworkProperties, etc. |
| IdentityBinding.tsp | IdentityBindingProperties, IdentityBindingManagedIdentityProfile, etc. |
| JWTAuthenticator.tsp | JWTAuthenticatorProperties, JWTAuthenticatorIssuer, etc. |
| MeshMembership.tsp | MeshMembershipProperties, MeshMembershipsListResult |
| MeshRevisionProfile.tsp | MeshRevisionProfileProperties, MeshRevisionProfileList |
| MeshUpgradeProfile.tsp | MeshUpgradeProfileProperties, MeshUpgradeProfileList |
| GuardrailsAvailableVersion.tsp | GuardrailsAvailableVersionsProperties, GuardrailsSupport |
| SafeguardsAvailableVersion.tsp | SafeguardsAvailableVersionsProperties, SafeguardsSupport |
| ManagedNamespace.tsp | NamespaceProperties, ResourceQuota, NetworkPolicies, etc. |
| AgentPoolUpgradeProfile.tsp | AgentPoolUpgradeProfileProperties |
| ManagedClusterUpgradeProfile.tsp | ManagedClusterUpgradeProfileProperties |
| ManagedCluster.tsp | RunCommandRequest/Result, OutboundEnvironmentEndpoint, etc. |

## Recommendations

1. **Accept current structure** - The ~5,000 line CommonModels.tsp contains genuinely shared types
2. **Don't force splits** - Artificial splitting creates maintenance burden and potential circular imports
3. **Follow the pattern** - New resources should have their own .tsp files with resource-specific models
4. **Keep operations and models together** - If an operation uses a model, they should be in the same file

## Future Considerations

If TypeSpec adds support for:
- Forward declarations
- Lazy type resolution for `@parentResource`

Then it may become possible to restructure so parent resources import children instead of vice versa.
