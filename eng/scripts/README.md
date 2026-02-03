# Resource Provider Fetching Scripts

This directory contains utility scripts for working with Azure REST API specifications.

## fetch_rp_without_service_groups.py

A Python script to identify and list Azure resource providers that do not have service groups.

**📖 New to this script?** Start with the [QUICKSTART.md](./QUICKSTART.md) guide for step-by-step instructions.

### Quick Start

**Where to run:** Navigate to the root of the `azure-rest-api-specs` repository

**How to run:**
```bash
# From the repository root directory
cd /path/to/azure-rest-api-specs

# Run the script
python eng/scripts/fetch_rp_without_service_groups.py
```

**Alternative:** Run from the scripts directory
```bash
# From the eng/scripts directory
cd /path/to/azure-rest-api-specs/eng/scripts

# Run the script (will auto-detect repo root)
python fetch_rp_without_service_groups.py
```

### Overview

In the Azure REST API specifications repository, resource providers are organized in different ways:

1. **Resource Providers WITH Service Groups** (like `Microsoft.Compute`):
   ```
   specification/compute/resource-manager/Microsoft.Compute/
   ├── CloudserviceRP/
   ├── ComputeRP/
   ├── DiskRP/
   └── ...
   ```

2. **Resource Providers WITHOUT Service Groups** (like `Microsoft.Storage`):
   ```
   specification/storage/resource-manager/Microsoft.Storage/
   ├── stable/
   └── preview/
   ```

This script identifies and lists resource providers that fall into the second category (no service groups).

### Usage

#### Where to Run the Script

The script can be run from **two locations**:

1. **From the repository root** (recommended):
   ```bash
   cd /path/to/azure-rest-api-specs
   python eng/scripts/fetch_rp_without_service_groups.py
   ```

2. **From the eng/scripts directory**:
   ```bash
   cd /path/to/azure-rest-api-specs/eng/scripts
   python fetch_rp_without_service_groups.py
   ```

The script automatically detects the repository root from your current location.

#### Basic Usage

List all resource providers without service groups:
```bash
python fetch_rp_without_service_groups.py
```

#### Options

**Specify repository root:**
```bash
python fetch_rp_without_service_groups.py --repo-root /path/to/azure-rest-api-specs
```

**Output formats:**

1. List format (default):
   ```bash
   # From repository root
   python eng/scripts/fetch_rp_without_service_groups.py --format list
   ```
   Output:
   ```
   Microsoft.Storage
   Microsoft.KeyVault
   ...
   ```

2. Table format:
   ```bash
   # From repository root
   python eng/scripts/fetch_rp_without_service_groups.py --format table
   ```
   Output:
   ```
   Resource Provider        Service       Path
   ----------------------  ------------  ------------------------------
   Microsoft.Storage       storage       specification/storage/...
   Microsoft.KeyVault      keyvault      specification/keyvault/...
   ...
   ```

3. JSON format:
   ```bash
   # From repository root
   python eng/scripts/fetch_rp_without_service_groups.py --format json
   ```
   Output:
   ```json
   [
     {
       "name": "Microsoft.Storage",
       "path": "specification/storage/resource-manager/Microsoft.Storage",
       "service": "storage"
     },
     ...
   ]
   ```

**Count only:**
```bash
# From repository root
python eng/scripts/fetch_rp_without_service_groups.py --count
```
Output:
```
106
```

### Examples

**Note:** All examples assume you're running from the repository root. If you're in `eng/scripts/`, omit the `eng/scripts/` path prefix.

Get the total count of resource providers without service groups:
```bash
# From repository root
cd /path/to/azure-rest-api-specs
count=$(python eng/scripts/fetch_rp_without_service_groups.py --count)
echo "Found $count resource providers without service groups"
```

Export results to a JSON file:
```bash
# From repository root
python eng/scripts/fetch_rp_without_service_groups.py --format json > rp_no_service_groups.json

# From eng/scripts directory
python fetch_rp_without_service_groups.py --format json > rp_no_service_groups.json
```

Filter results using grep:
```bash
# From repository root
python eng/scripts/fetch_rp_without_service_groups.py | grep -i storage
```

### Requirements

- Python 3.6 or higher
- No external dependencies (uses only standard library)
- Must be run from within the `azure-rest-api-specs` repository directory

### Troubleshooting

**Issue: "Specification directory not found"**
- **Cause:** Running the script from outside the repository
- **Solution:** Make sure you're inside the `azure-rest-api-specs` directory, or use the `--repo-root` option:
  ```bash
  python fetch_rp_without_service_groups.py --repo-root /path/to/azure-rest-api-specs
  ```

**Issue: "Command not found: python"**
- **Cause:** Python is not installed or not in PATH
- **Solution:** Try `python3` instead:
  ```bash
  python3 eng/scripts/fetch_rp_without_service_groups.py
  ```

**Issue: Script runs but shows 0 results**
- **Cause:** Not in the correct directory or repository structure has changed
- **Solution:** Verify you're in the azure-rest-api-specs repository and the `specification/` directory exists

### Testing

Run the test suite to verify the script functionality:
```bash
# From repository root
cd /path/to/azure-rest-api-specs
python eng/scripts/test_fetch_rp.py

# Or from eng/scripts directory
cd /path/to/azure-rest-api-specs/eng/scripts
python test_fetch_rp.py
```

The test suite validates:
- Count output returns a valid number
- List format produces correct output
- JSON format produces valid JSON with correct structure
- Table format produces properly formatted tables
- Known providers are correctly identified (e.g., Storage/KeyVault included, Compute excluded)

### Implementation Details

The script:
1. Scans the `specification/*/resource-manager/` directory for `Microsoft.*` directories (resource providers)
2. For each resource provider, checks for subdirectories that are NOT:
   - `stable` or `preview` (API version directories)
   - `common-types` (shared type definitions)
   - `examples` (example files)
3. If no service group directories are found AND the resource provider has `stable` or `preview` directories, it's included in the results
4. Results are sorted alphabetically by resource provider name
