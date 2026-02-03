# Resource Provider Fetching Scripts

This directory contains utility scripts for working with Azure REST API specifications.

## fetch_rp_without_service_groups.py

A Python script to identify and list Azure resource providers that do not have service groups.

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
   python fetch_rp_without_service_groups.py --format list
   ```
   Output:
   ```
   Microsoft.Storage (storage)
   Microsoft.KeyVault (keyvault)
   ...
   ```

2. Table format:
   ```bash
   python fetch_rp_without_service_groups.py --format table
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
   python fetch_rp_without_service_groups.py --format json
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
python fetch_rp_without_service_groups.py --count
```
Output:
```
106
```

### Examples

Get the total count of resource providers without service groups:
```bash
count=$(python fetch_rp_without_service_groups.py --count)
echo "Found $count resource providers without service groups"
```

Export results to a JSON file:
```bash
python fetch_rp_without_service_groups.py --format json > rp_no_service_groups.json
```

Filter results using grep:
```bash
python fetch_rp_without_service_groups.py | grep -i storage
```

### Requirements

- Python 3.6 or higher
- No external dependencies (uses only standard library)

### Implementation Details

The script:
1. Scans the `specification/*/resource-manager/` directory for `Microsoft.*` directories (resource providers)
2. For each resource provider, checks for subdirectories that are NOT:
   - `stable` or `preview` (API version directories)
   - `common-types` (shared type definitions)
   - `examples` (example files)
3. If no service group directories are found AND the resource provider has `stable` or `preview` directories, it's included in the results
4. Results are sorted alphabetically by resource provider name
