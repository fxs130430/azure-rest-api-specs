# Examples: Using generate-lease-files.js

This document provides practical examples of using the `generate-lease-files.js` script with output from `fetch-resource-providers.js`.

## Prerequisites

Ensure you have both scripts available:
- `eng/scripts/fetch-resource-providers.js` (from PR #40116)
- `eng/scripts/generate-lease-files.js`

## Example 1: Generate Leases for All RPs Without Service Groups

This example shows how to generate lease files for all resource providers that don't use service groups.

```bash
# Step 1: Get list of RPs without service groups
node eng/scripts/fetch-resource-providers.js > /tmp/rps-no-groups.txt

# The output looks like:
# storage, Microsoft.Storage
# network, Microsoft.Network
# keyvault, Microsoft.KeyVault
# ...

# Step 2: Preview what would be created (dry-run)
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-no-groups.txt \
  --reviewer "John Doe" \
  --dry-run

# Step 3: Actually create the lease files
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-no-groups.txt \
  --reviewer "John Doe"

# This creates files like:
# .github/arm-leases/storage/Microsoft.Storage/lease.yaml
# .github/arm-leases/network/Microsoft.Network/lease.yaml
# .github/arm-leases/keyvault/Microsoft.KeyVault/lease.yaml
```

## Example 2: Generate Leases for All RPs With Service Groups

This example shows how to generate lease files for resource providers that use service groups.

```bash
# Step 1: Get list of RPs with service groups
node eng/scripts/fetch-resource-providers.js --with-service-groups > /tmp/rps-with-groups.txt

# The output looks like:
# compute, Microsoft.Compute, [ComputeRP, DiskRP, GalleryRP, RecommenderRP, Skus]
# azurearcdata, Microsoft.AzureArcData, [DataControllers, SqlInstances]
# ...

# Step 2: Generate lease files with a custom start date
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-with-groups.txt \
  --reviewer "Jane Smith" \
  --startdate 2026-06-01

# This creates files like:
# .github/arm-leases/compute/Microsoft.Compute/ComputeRP/lease.yaml
# .github/arm-leases/compute/Microsoft.Compute/DiskRP/lease.yaml
# .github/arm-leases/compute/Microsoft.Compute/GalleryRP/lease.yaml
# .github/arm-leases/azurearcdata/Microsoft.AzureArcData/DataControllers/lease.yaml
# .github/arm-leases/azurearcdata/Microsoft.AzureArcData/SqlInstances/lease.yaml
```

## Example 3: Generate Leases for Specific RPs from Filtered List

This example filters the RP list and generates leases only for specific ones.

```bash
# Step 1: Get all RPs and filter for specific ones
node eng/scripts/fetch-resource-providers.js | grep -E "(storage|network|compute)" > /tmp/filtered-rps.txt

# Step 2: Generate lease files for filtered list
node eng/scripts/generate-lease-files.js \
  --input /tmp/filtered-rps.txt \
  --reviewer "PM Name" \
  --startdate 2026-07-01 \
  --duration P90D
```

## Example 4: Single Resource Provider

Create a lease for a single resource provider without using input file.

```bash
# Without service groups
node eng/scripts/generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "Alice Johnson"

# With service groups
node eng/scripts/generate-lease-files.js \
  --service compute \
  --rp Microsoft.Compute \
  --sg "ComputeRP,DiskRP" \
  --reviewer "Bob Smith"
```

## Example 5: Interactive Mode

Use interactive mode for custom input.

```bash
node eng/scripts/generate-lease-files.js --interactive

# You'll be prompted for:
# - Reviewer name
# - Start date (default: today)
# - Duration (default: P180D)
# - List of resource provider entries (one per line)

# Example input during interactive session:
# Enter reviewer name: Jane Doe
# Enter start date [2026-02-17]: 2026-06-01
# Enter duration [P180D]: P180D
# Enter resource provider entries (one per line, empty line to finish):
# > storage, Microsoft.Storage
# > compute, Microsoft.Compute, [ComputeRP, DiskRP]
# >
```

## Example 6: Custom Input File Format

Create a custom input file with comments and mixed formats.

```bash
# Create custom input file
cat > /tmp/my-rps.txt << 'EOF'
# High priority RPs
storage, Microsoft.Storage
network, Microsoft.Network

# RPs with service groups
compute, Microsoft.Compute, [ComputeRP, DiskRP, GalleryRP]
azurearcdata, Microsoft.AzureArcData, [DataControllers, SqlInstances]

# More RPs
keyvault, Microsoft.KeyVault
EOF

# Generate lease files
node eng/scripts/generate-lease-files.js \
  --input /tmp/my-rps.txt \
  --reviewer "Team Lead"
```

## Example 7: Using Different Reviewers for Different Sets

If you need different reviewers for different sets of RPs:

```bash
# Set 1: Storage-related RPs
cat > /tmp/storage-rps.txt << 'EOF'
storage, Microsoft.Storage
backup, Microsoft.Backup
EOF

node eng/scripts/generate-lease-files.js \
  --input /tmp/storage-rps.txt \
  --reviewer "Storage Team PM"

# Set 2: Compute-related RPs
cat > /tmp/compute-rps.txt << 'EOF'
compute, Microsoft.Compute, [ComputeRP, DiskRP]
containerservice, Microsoft.ContainerService
EOF

node eng/scripts/generate-lease-files.js \
  --input /tmp/compute-rps.txt \
  --reviewer "Compute Team PM"
```

## Example 8: Batch Processing with Different Dates

Generate leases for different phases with different start dates.

```bash
# Phase 1 - Starting June 2026
node eng/scripts/generate-lease-files.js \
  --input /tmp/phase1-rps.txt \
  --reviewer "Phase 1 PM" \
  --startdate 2026-06-01

# Phase 2 - Starting September 2026
node eng/scripts/generate-lease-files.js \
  --input /tmp/phase2-rps.txt \
  --reviewer "Phase 2 PM" \
  --startdate 2026-09-01 \
  --duration P120D
```

## Example 9: Verify Before Creating

Always preview with dry-run before creating actual files.

```bash
# Step 1: Dry run to preview
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps.txt \
  --reviewer "Test" \
  --dry-run

# Review the output...

# Step 2: If everything looks good, create the files
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps.txt \
  --reviewer "Actual Name"
```

## Example 10: Complete Workflow

A complete workflow from fetching to creating lease files.

```bash
#!/bin/bash

# Set variables
REVIEWER="John Doe"
START_DATE="2026-06-01"
DURATION="P180D"

# Fetch RPs without service groups
echo "Fetching RPs without service groups..."
node eng/scripts/fetch-resource-providers.js > /tmp/rps-no-groups.txt

# Fetch RPs with service groups
echo "Fetching RPs with service groups..."
node eng/scripts/fetch-resource-providers.js --with-service-groups > /tmp/rps-with-groups.txt

# Preview what will be created
echo ""
echo "Preview for RPs without service groups:"
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-no-groups.txt \
  --reviewer "$REVIEWER" \
  --startdate "$START_DATE" \
  --duration "$DURATION" \
  --dry-run | head -50

echo ""
echo "Preview for RPs with service groups:"
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-with-groups.txt \
  --reviewer "$REVIEWER" \
  --startdate "$START_DATE" \
  --duration "$DURATION" \
  --dry-run | head -50

# Ask for confirmation
echo ""
read -p "Do you want to create the lease files? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
  echo "Creating lease files for RPs without service groups..."
  node eng/scripts/generate-lease-files.js \
    --input /tmp/rps-no-groups.txt \
    --reviewer "$REVIEWER" \
    --startdate "$START_DATE" \
    --duration "$DURATION"
  
  echo ""
  echo "Creating lease files for RPs with service groups..."
  node eng/scripts/generate-lease-files.js \
    --input /tmp/rps-with-groups.txt \
    --reviewer "$REVIEWER" \
    --startdate "$START_DATE" \
    --duration "$DURATION"
  
  echo ""
  echo "Done! Review the created files with:"
  echo "  find .github/arm-leases -name 'lease.yaml' | head -20"
else
  echo "Operation cancelled."
fi
```

## Output Structure Examples

### For RP without service groups:
```
.github/arm-leases/
└── storage/
    └── Microsoft.Storage/
        └── lease.yaml
```

Content of `lease.yaml`:
```yaml
lease:
  resource-provider: Microsoft.Storage
  startdate: 2026-06-01
  duration-days: P180D
  reviewer: John Doe
```

### For RP with service groups:
```
.github/arm-leases/
└── compute/
    └── Microsoft.Compute/
        ├── ComputeRP/
        │   └── lease.yaml
        ├── DiskRP/
        │   └── lease.yaml
        └── GalleryRP/
            └── lease.yaml
```

Each `lease.yaml` has the same content:
```yaml
lease:
  resource-provider: Microsoft.Compute
  startdate: 2026-06-01
  duration-days: P180D
  reviewer: Jane Smith
```

## Tips

1. **Always use dry-run first**: Preview what will be created before actually creating files
2. **Use meaningful reviewer names**: Full names are better than aliases
3. **Plan your dates**: Consider team schedules when setting start dates
4. **Check for existing files**: The script won't overwrite existing files
5. **Use version control**: Commit lease files to your branch for review
6. **Validate paths**: The script validates service names and RP names according to ARM lease rules

## Common Patterns

### Pattern 1: Generate leases for entire repository
```bash
node eng/scripts/fetch-resource-providers.js > /tmp/all-rps.txt
node eng/scripts/fetch-resource-providers.js --with-service-groups >> /tmp/all-rps.txt
node eng/scripts/generate-lease-files.js --input /tmp/all-rps.txt --reviewer "PM Name"
```

### Pattern 2: Generate leases for specific service
```bash
node eng/scripts/fetch-resource-providers.js | grep "^compute," > /tmp/compute-rps.txt
node eng/scripts/generate-lease-files.js --input /tmp/compute-rps.txt --reviewer "Compute PM"
```

### Pattern 3: Update existing leases (delete and recreate)
```bash
# Delete existing leases
rm -rf .github/arm-leases/storage/

# Recreate with new dates
node eng/scripts/generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "Updated PM" \
  --startdate 2026-07-01
```
