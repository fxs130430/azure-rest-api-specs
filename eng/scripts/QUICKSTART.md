# Quick Start Guide

This is a simple step-by-step guide to run the `fetch_rp_without_service_groups.py` script.

## Prerequisites

- Python 3.6 or higher installed
- You have cloned the `azure-rest-api-specs` repository

## Step-by-Step Instructions

### Step 1: Open Terminal/Command Prompt

Open your terminal (Linux/Mac) or Command Prompt/PowerShell (Windows).

### Step 2: Navigate to the Repository

```bash
cd /path/to/azure-rest-api-specs
```

Replace `/path/to/azure-rest-api-specs` with the actual path where you cloned the repository.

**Examples:**
- Windows: `cd C:\Users\YourName\azure-rest-api-specs`
- Mac/Linux: `cd ~/Documents/azure-rest-api-specs`

### Step 3: Run the Script

**To get a count of resource providers:**
```bash
python eng/scripts/fetch_rp_without_service_groups.py --count
```

**To see the full list:**
```bash
python eng/scripts/fetch_rp_without_service_groups.py
```

**To see results in a table:**
```bash
python eng/scripts/fetch_rp_without_service_groups.py --format table
```

### Step 4: View the Results

The script will display a list of Azure resource providers that don't have service groups.

Example output:
```
Microsoft.Storage
Microsoft.KeyVault
Microsoft.Network
...

Total: 106 resource provider(s) without service groups
```

## Alternative: Run from Scripts Directory

You can also navigate directly to the scripts directory:

```bash
cd /path/to/azure-rest-api-specs/eng/scripts
python fetch_rp_without_service_groups.py
```

The script automatically detects the repository root, so it works from any directory within the repository!

## Common Issues

### "python: command not found"

Try using `python3` instead:
```bash
python3 eng/scripts/fetch_rp_without_service_groups.py --count
```

### "Specification directory not found"

Make sure you're inside the `azure-rest-api-specs` repository directory. The script needs to find the `specification/` folder.

### Need more options?

Run the script with `--help` to see all available options:
```bash
python eng/scripts/fetch_rp_without_service_groups.py --help
```

## What Does This Script Do?

This script identifies Azure resource providers that are organized differently:

- **WITHOUT service groups** (like Microsoft.Storage): Files are directly in `stable/` and `preview/` folders
- **WITH service groups** (like Microsoft.Compute): Files are organized in subfolders like `CloudserviceRP/`, `ComputeRP/`, etc.

The script lists only those resource providers WITHOUT service groups.

## Need More Help?

See the full documentation in [README.md](./README.md) for advanced usage, examples, and troubleshooting.
