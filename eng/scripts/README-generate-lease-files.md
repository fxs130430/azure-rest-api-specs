# Generate Lease Files Script

This script generates ARM lease.yaml files based on resource provider data from the `fetch-resource-providers.js` script.

## Overview

The `generate-lease-files.js` script helps Product Managers (PMs) create ARM lease files following the structure defined in PR #39495. It takes input from the `fetch-resource-providers.js` script (PR #40116) and generates properly formatted lease.yaml files.

## Prerequisites

- Node.js installed
- Run from within the azure-rest-api-specs repository

## Usage

### 1. Using with fetch-resource-providers.js Output

This is the recommended approach for bulk operations.

#### For RPs without service groups:
```bash
# Get list of RPs without service groups
node eng/scripts/fetch-resource-providers.js > rps-without-groups.txt

# Generate lease files (reviewer name is asked once)
node eng/scripts/generate-lease-files.js --input rps-without-groups.txt --reviewer "Your Name"
```

#### For RPs with service groups:
```bash
# Get list of RPs with service groups
node eng/scripts/fetch-resource-providers.js --with-service-groups > rps-with-groups.txt

# Generate lease files
node eng/scripts/generate-lease-files.js --input rps-with-groups.txt --reviewer "Your Name"
```

### 2. Single Resource Provider

For creating lease files for a single RP:

#### Without service groups:
```bash
node eng/scripts/generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "John Doe"
```

#### With service groups:
```bash
node eng/scripts/generate-lease-files.js \
  --service compute \
  --rp Microsoft.Compute \
  --sg "ComputeRP,DiskRP,GalleryRP" \
  --reviewer "Jane Smith"
```

### 3. Interactive Mode

For an interactive prompt-based experience:

```bash
node eng/scripts/generate-lease-files.js --interactive
```

This will prompt you for:
- Reviewer name
- Start date (default: today)
- Duration (default: P180D)
- List of resource provider entries

### 4. Custom Options

```bash
node eng/scripts/generate-lease-files.js \
  --input rps.txt \
  --reviewer "Your Name" \
  --startdate 2026-06-01 \
  --duration P90D
```

### 5. Dry Run (Preview)

To preview what will be created without actually creating files:

```bash
node eng/scripts/generate-lease-files.js \
  --input rps.txt \
  --reviewer "Test" \
  --dry-run
```

## Command Line Options

| Option | Short | Description | Required |
|--------|-------|-------------|----------|
| `--input <file>` | | Input file containing RP data | Yes* |
| `--service <name>` | | Service name (lowercase alphanumeric) | Yes* |
| `--resource-provider <name>` | `--rp` | Resource provider name (e.g., Microsoft.Test) | Yes* |
| `--service-groups <list>` | `--sg` | Comma-separated service groups | No |
| `--reviewer <name>` | | Reviewer name | Yes |
| `--startdate <YYYY-MM-DD>` | | Lease start date (default: today) | No |
| `--duration <P#D>` | | Lease duration (default: P180D, max: P180D) | No |
| `--repo-root <path>` | | Repository root path (auto-detected) | No |
| `--dry-run` | | Preview mode - don't create files | No |
| `--interactive` | `-i` | Interactive mode with prompts | No |
| `--help` | `-h` | Show help message | No |

\* Either `--input` OR both `--service` and `--resource-provider` are required

## Input File Format

The input file should contain one entry per line in CSV format:

### Without service groups:
```
service, resource_provider
```

Example:
```
storage, Microsoft.Storage
network, Microsoft.Network
keyvault, Microsoft.KeyVault
```

### With service groups:
```
service, resource_provider, [group1, group2, ...]
```

Example:
```
compute, Microsoft.Compute, [ComputeRP, DiskRP, GalleryRP]
azurearcdata, Microsoft.AzureArcData, [DataControllers, SqlInstances]
```

### Comments
Lines starting with `#` are treated as comments and ignored.

## Output Structure

The script creates lease.yaml files following this structure:

### Without service groups:
```
.github/arm-leases/<service>/<resource-provider>/lease.yaml
```

Example:
```
.github/arm-leases/storage/Microsoft.Storage/lease.yaml
```

### With service groups:
```
.github/arm-leases/<service>/<resource-provider>/<service-group>/lease.yaml
```

Example:
```
.github/arm-leases/compute/Microsoft.Compute/ComputeRP/lease.yaml
.github/arm-leases/compute/Microsoft.Compute/DiskRP/lease.yaml
```

## Lease File Format

Each generated lease.yaml file contains:

```yaml
lease:
  resource-provider: Microsoft.TestRP
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: John Doe
```

## Validation

The script validates:
- Service name: must be lowercase alphanumeric
- Resource provider: parts must start with capital letter
- Start date: must be in YYYY-MM-DD format and not in the past
- Duration: must be in P#D format, between 1 and 180 days
- Reviewer: cannot be empty

## Examples

### Example 1: Process all RPs without service groups
```bash
# Step 1: Fetch RPs
node eng/scripts/fetch-resource-providers.js > /tmp/rps.txt

# Step 2: Review the list (optional)
cat /tmp/rps.txt

# Step 3: Generate lease files
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps.txt \
  --reviewer "John Doe"
```

### Example 2: Process all RPs with service groups
```bash
# Step 1: Fetch RPs with groups
node eng/scripts/fetch-resource-providers.js --with-service-groups > /tmp/rps-groups.txt

# Step 2: Generate lease files
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps-groups.txt \
  --reviewer "Jane Smith" \
  --startdate 2026-06-01
```

### Example 3: Create lease for a specific RP
```bash
# Without service groups
node eng/scripts/generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "PM Name"

# With service groups
node eng/scripts/generate-lease-files.js \
  --service compute \
  --rp Microsoft.Compute \
  --sg "ComputeRP,DiskRP" \
  --reviewer "PM Name"
```

### Example 4: Preview before creating
```bash
node eng/scripts/generate-lease-files.js \
  --input /tmp/rps.txt \
  --reviewer "Test" \
  --dry-run
```

### Example 5: Create from custom input file
```bash
# Create a custom input file
cat > /tmp/my-rps.txt << EOF
# My resource providers
storage, Microsoft.Storage
compute, Microsoft.Compute, [ComputeRP, DiskRP]
EOF

# Generate lease files
node eng/scripts/generate-lease-files.js \
  --input /tmp/my-rps.txt \
  --reviewer "My Name"
```

## Related Scripts

- **fetch-resource-providers.js**: Scans the repository and outputs lists of resource providers
  - Use without `--with-service-groups` flag for RPs without service groups
  - Use with `--with-service-groups` flag for RPs with service groups

## Testing

Run the test suite:
```bash
node eng/scripts/Tests/generate-lease-files.test.js
```

## Troubleshooting

### Error: "Could not find repository root"
Make sure you're running the script from within the azure-rest-api-specs repository.

### Error: "Service name must be lowercase alphanumeric"
Service names in the folder structure must be lowercase and contain only letters and numbers.

### Error: "Resource provider parts must start with capital letter"
Resource provider names like `Microsoft.Test` must have each part start with a capital letter.

### Error: "Startdate cannot be in the past"
The start date must be today or a future date. Use `--startdate` to specify a future date.

### Error: "Duration must be between 1 and 180 days"
Lease duration cannot exceed 180 days (P180D). Adjust with `--duration`.

### Warning: "File already exists, skipping"
The script won't overwrite existing lease files. Delete the existing file if you want to regenerate it.

## Notes

- The script automatically creates parent directories as needed
- Existing lease files are never overwritten (a warning is shown instead)
- The reviewer name is asked only once and applied to all generated lease files
- Comments (lines starting with `#`) in input files are ignored
- Empty lines in input files are ignored
- Service groups "stable" and "preview" are not allowed as they conflict with API versioning folders

## See Also

- PR #40116: fetch-resource-providers.js script
- PR #39495: ARM lease validation workflow and structure
- `.github/arm-leases/README.md`: ARM leases documentation
