# Generate Lease Files - Input & Output Examples

This document shows practical examples of how to use the `generate-lease-files.js` script with different input formats and their corresponding outputs.

## Quick Reference

**Command Format:**
```bash
node generate-lease-files.js [OPTIONS]
```

**Key Options:**
- `--input <file>` - Input file with RP data
- `--service <name>` - Single service name
- `--resource-provider, --rp <name>` - Resource provider name
- `--service-groups, --sg <list>` - Comma-separated service groups
- `--reviewer <name>` - Reviewer name (REQUIRED)
- `--startdate <YYYY-MM-DD>` - Start date (default: today)
- `--duration <P#D>` - Duration (default: P180D)
- `--dry-run` - Preview without creating files
- `--interactive, -i` - Interactive mode

---

## Example 1: Input File Format (CSV)

### INPUT FILE: `rps.txt`
```csv
# Lines starting with # are comments
storage, Microsoft.Storage
network, Microsoft.Network
keyvault, Microsoft.KeyVault
```

### COMMAND:
```bash
node generate-lease-files.js --input rps.txt --reviewer "John Doe" --dry-run
```

### OUTPUT:
```
Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: John Doe
Start date: 2026-02-17
Duration: P180D

[DRY RUN] Would create: .github/arm-leases/storage/Microsoft.Storage/lease.yaml
lease:
  resource-provider: Microsoft.Storage
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: John Doe

---
[DRY RUN] Would create: .github/arm-leases/network/Microsoft.Network/lease.yaml
lease:
  resource-provider: Microsoft.Network
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: John Doe

---
[DRY RUN] Would create: .github/arm-leases/keyvault/Microsoft.KeyVault/lease.yaml
lease:
  resource-provider: Microsoft.KeyVault
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: John Doe

---

Processed 3 entries
```

### CREATED FILES:
```
.github/arm-leases/
├── storage/
│   └── Microsoft.Storage/
│       └── lease.yaml
├── network/
│   └── Microsoft.Network/
│       └── lease.yaml
└── keyvault/
    └── Microsoft.KeyVault/
        └── lease.yaml
```

---

## Example 2: Input File with Service Groups

### INPUT FILE: `rps-with-groups.txt`
```csv
compute, Microsoft.Compute, [ComputeRP, DiskRP, GalleryRP]
azurearcdata, Microsoft.AzureArcData, [DataControllers, SqlInstances]
```

### COMMAND:
```bash
node generate-lease-files.js --input rps-with-groups.txt --reviewer "Jane Smith" --dry-run
```

### OUTPUT:
```
Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: Jane Smith
Start date: 2026-02-17
Duration: P180D

[DRY RUN] Would create: .github/arm-leases/compute/Microsoft.Compute/ComputeRP/lease.yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Jane Smith

---
[DRY RUN] Would create: .github/arm-leases/compute/Microsoft.Compute/DiskRP/lease.yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Jane Smith

---
[DRY RUN] Would create: .github/arm-leases/compute/Microsoft.Compute/GalleryRP/lease.yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Jane Smith

---
[DRY RUN] Would create: .github/arm-leases/azurearcdata/Microsoft.AzureArcData/DataControllers/lease.yaml
lease:
  resource-provider: Microsoft.AzureArcData
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Jane Smith

---
[DRY RUN] Would create: .github/arm-leases/azurearcdata/Microsoft.AzureArcData/SqlInstances/lease.yaml
lease:
  resource-provider: Microsoft.AzureArcData
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Jane Smith

---

Processed 2 entries
```

### CREATED FILES:
```
.github/arm-leases/
├── compute/
│   └── Microsoft.Compute/
│       ├── ComputeRP/
│       │   └── lease.yaml
│       ├── DiskRP/
│       │   └── lease.yaml
│       └── GalleryRP/
│           └── lease.yaml
└── azurearcdata/
    └── Microsoft.AzureArcData/
        ├── DataControllers/
        │   └── lease.yaml
        └── SqlInstances/
            └── lease.yaml
```

---

## Example 3: Single Resource Provider (Command Line)

### COMMAND:
```bash
node generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "Alice Johnson" \
  --startdate 2026-06-01 \
  --duration P90D \
  --dry-run
```

### OUTPUT:
```
Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: Alice Johnson
Start date: 2026-06-01
Duration: P90D

[DRY RUN] Would create: .github/arm-leases/storage/Microsoft.Storage/lease.yaml
lease:
  resource-provider: Microsoft.Storage
  startdate: 2026-06-01
  duration-days: P90D
  reviewer: Alice Johnson

---

Processed 1 entries
```

---

## Example 4: Single RP with Service Groups

### COMMAND:
```bash
node generate-lease-files.js \
  --service compute \
  --rp Microsoft.Compute \
  --sg "ComputeRP,DiskRP" \
  --reviewer "Bob Smith" \
  --dry-run
```

### OUTPUT:
```
Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: Bob Smith
Start date: 2026-02-17
Duration: P180D

[DRY RUN] Would create: .github/arm-leases/compute/Microsoft.Compute/ComputeRP/lease.yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Bob Smith

---
[DRY RUN] Would create: .github/arm-leases/compute/Microsoft.Compute/DiskRP/lease.yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Bob Smith

---

Processed 1 entries
```

---

## Example 5: Interactive Mode

### COMMAND:
```bash
node generate-lease-files.js --interactive
```

### INTERACTIVE SESSION:
```
Interactive Lease File Generator
=================================

Enter reviewer name (required): John Doe
Enter start date [YYYY-MM-DD] (default: 2026-02-17): 2026-06-01
Enter duration [P#D] (default: P180D): P180D

Enter resource provider entries (one per line, empty line to finish):
Format: service, resource_provider, [optional_groups]
Example: storage, Microsoft.Storage
Example: compute, Microsoft.Compute, [ComputeRP, DiskRP]

> storage, Microsoft.Storage
> network, Microsoft.Network
> 

Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: John Doe
Start date: 2026-06-01
Duration: P180D

Created: .github/arm-leases/storage/Microsoft.Storage/lease.yaml
Created: .github/arm-leases/network/Microsoft.Network/lease.yaml

Processed 2 entries
```

---

## Example 6: Actual File Creation (Without --dry-run)

### COMMAND:
```bash
node generate-lease-files.js \
  --service testservice \
  --rp Microsoft.TestRP \
  --reviewer "Test User"
```

### OUTPUT:
```
Repository root: /home/runner/work/azure-rest-api-specs/azure-rest-api-specs
Reviewer: Test User
Start date: 2026-02-17
Duration: P180D

Created: .github/arm-leases/testservice/Microsoft.TestRP/lease.yaml

Processed 1 entries
```

### FILE CREATED: `.github/arm-leases/testservice/Microsoft.TestRP/lease.yaml`
```yaml
lease:
  resource-provider: Microsoft.TestRP
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: Test User
```

---

## Input File Format Reference

### Without Service Groups:
```
service_name, Resource.Provider
```

### With Service Groups:
```
service_name, Resource.Provider, [Group1, Group2, Group3]
```

### Rules:
- Service names must be **lowercase alphanumeric**
- Resource providers must start with **capital letters** (e.g., Microsoft.Storage)
- Comments start with `#`
- Empty lines are ignored
- Service groups are optional and enclosed in `[brackets]`

---

## Common Use Cases

### Use Case 1: Generate from fetch-resource-providers.js
```bash
# Get RPs without service groups
node fetch-resource-providers.js > rps.txt
node generate-lease-files.js --input rps.txt --reviewer "PM Name"

# Get RPs with service groups
node fetch-resource-providers.js --with-service-groups > rps-groups.txt
node generate-lease-files.js --input rps-groups.txt --reviewer "PM Name"
```

### Use Case 2: Preview Before Creating
```bash
# Always use --dry-run first to preview
node generate-lease-files.js --input rps.txt --reviewer "Test" --dry-run

# Then create actual files
node generate-lease-files.js --input rps.txt --reviewer "Actual Name"
```

### Use Case 3: Custom Start Date and Duration
```bash
node generate-lease-files.js \
  --input rps.txt \
  --reviewer "PM Name" \
  --startdate 2026-09-01 \
  --duration P120D
```

---

## Error Messages

### Invalid Service Name:
```
Error processing TestService/Microsoft.Test: Service name must be lowercase alphanumeric: TestService
```

### Invalid Resource Provider:
```
Error processing storage/microsoft.Storage: Resource provider parts must start with capital letter: microsoft.Storage
```

### Missing Required Field:
```
Error: --reviewer is required
Use --help for usage information
```

### Invalid Date:
```
Error: Invalid date format: 01-15-2026. Expected YYYY-MM-DD
```

### Date in Past:
```
Error: Startdate cannot be in the past: 2025-01-01
```

### Invalid Duration:
```
Error: Invalid duration format: 200 days. Expected P#D (e.g., P180D)
Error: Duration must be between 1 and 180 days. Got: 200
```

---

## Tips

1. **Always use --dry-run first** to preview what will be created
2. **Reviewer name** is required for all operations
3. **Service names** must be lowercase (e.g., `storage`, not `Storage`)
4. **Resource providers** must use PascalCase (e.g., `Microsoft.Storage`)
5. **Max duration** is 180 days (P180D)
6. **Files won't be overwritten** - the script warns and skips existing files
7. **Use comments** in input files to organize your entries

---

## Quick Start

```bash
# 1. Create input file
cat > my-rps.txt << EOF
storage, Microsoft.Storage
network, Microsoft.Network
EOF

# 2. Preview output
node generate-lease-files.js --input my-rps.txt --reviewer "Your Name" --dry-run

# 3. Create files
node generate-lease-files.js --input my-rps.txt --reviewer "Your Name"

# 4. Verify
find .github/arm-leases -name "lease.yaml" | head -5
```
