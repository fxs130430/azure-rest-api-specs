# Summary: Generate Lease Files Script

## Problem Statement
Create a JavaScript script that takes input from PR #40116's `fetch-resource-providers.js` and generates `lease.yaml` files following the structure and format from PR #39495.

## Solution Delivered

### Created Files
1. **eng/scripts/generate-lease-files.js** (15,751 bytes)
   - Main script for generating lease.yaml files
   - Supports multiple input modes
   
2. **eng/scripts/Tests/generate-lease-files.test.js** (7,830 bytes)
   - Comprehensive test suite
   - All tests passing
   
3. **eng/scripts/README-generate-lease-files.md** (8,199 bytes)
   - Complete documentation
   - Usage instructions
   - Troubleshooting guide
   
4. **eng/scripts/EXAMPLES-generate-lease-files.md** (9,923 bytes)
   - 10 practical examples
   - Complete workflows
   - Common patterns
   
5. **Updated .gitignore**
   - Added `!eng/scripts/**/*.js` to allow script files

## Key Features

### Input Modes
1. **From File**: Reads CSV format from fetch-resource-providers.js output
2. **Single RP**: Create lease for one resource provider
3. **Interactive**: Prompt-based input for manual entry

### Input Format Support
- **Without service groups**: `service, resource_provider`
- **With service groups**: `service, resource_provider, [group1, group2, ...]`
- Supports comments (lines starting with `#`)
- Ignores empty lines

### Validation
- Service name: lowercase alphanumeric only
- Resource provider: parts must start with capital letter
- Start date: YYYY-MM-DD format, not in the past
- Duration: P#D format, 1-180 days max
- Reviewer: required, cannot be empty

### Output Structure
- **Without service groups**: `.github/arm-leases/<service>/<rp>/lease.yaml`
- **With service groups**: `.github/arm-leases/<service>/<rp>/<group>/lease.yaml`

### Lease File Format
```yaml
lease:
  resource-provider: Microsoft.TestRP
  startdate: 2026-02-17
  duration-days: P180D
  reviewer: John Doe
```

## Usage Examples

### Basic Usage
```bash
# From fetch-resource-providers.js output
node eng/scripts/fetch-resource-providers.js > rps.txt
node eng/scripts/generate-lease-files.js --input rps.txt --reviewer "Your Name"

# Single RP
node eng/scripts/generate-lease-files.js \
  --service storage \
  --rp Microsoft.Storage \
  --reviewer "John Doe"

# With service groups
node eng/scripts/generate-lease-files.js \
  --service compute \
  --rp Microsoft.Compute \
  --sg "ComputeRP,DiskRP" \
  --reviewer "Jane Smith"

# Interactive mode
node eng/scripts/generate-lease-files.js --interactive

# Dry run (preview)
node eng/scripts/generate-lease-files.js \
  --input rps.txt \
  --reviewer "Test" \
  --dry-run
```

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--input <file>` | Input file with RP data | - |
| `--service <name>` | Service name | - |
| `--resource-provider, --rp` | Resource provider name | - |
| `--service-groups, --sg` | Comma-separated groups | - |
| `--reviewer <name>` | Reviewer name (required) | - |
| `--startdate <date>` | Start date (YYYY-MM-DD) | today |
| `--duration <P#D>` | Lease duration | P180D |
| `--repo-root <path>` | Repository root | auto-detect |
| `--dry-run` | Preview without creating | false |
| `--interactive, -i` | Interactive mode | false |
| `--help, -h` | Show help | - |

## Integration with fetch-resource-providers.js

The script is designed to work seamlessly with the output from `fetch-resource-providers.js` (PR #40116):

```bash
# Get RPs without service groups
node eng/scripts/fetch-resource-providers.js > rps-no-groups.txt

# Get RPs with service groups
node eng/scripts/fetch-resource-providers.js --with-service-groups > rps-with-groups.txt

# Generate leases
node eng/scripts/generate-lease-files.js --input rps-no-groups.txt --reviewer "PM Name"
node eng/scripts/generate-lease-files.js --input rps-with-groups.txt --reviewer "PM Name"
```

## Compliance with PR #39495

The script generates lease files that comply with the validation rules from PR #39495:

### Folder Structure ✓
- Follows `.github/arm-leases/<service>/<namespace>/[<group>]/lease.yaml` pattern
- Service name: lowercase alphanumeric
- Resource provider: capital letter start
- Service group: optional, not "stable" or "preview"

### File Format ✓
- YAML format with `lease` root key
- Required fields: resource-provider, startdate, duration-days, reviewer
- Date format: YYYY-MM-DD (ISO 8601)
- Duration format: P#D (ISO 8601)
- Max duration: P180D (180 days)

### Validation ✓
- Start date cannot be in the past
- Resource provider must match folder name
- All fields are required
- Proper formatting enforced

## Testing

All tests pass successfully:

```bash
node eng/scripts/Tests/generate-lease-files.test.js
```

Test coverage:
- ✓ parseInputLine - CSV parsing
- ✓ generateLeaseYaml - YAML generation
- ✓ getLeasePath - Path construction
- ✓ validateStartDate - Date validation
- ✓ validateDuration - Duration validation
- ✓ validateResourceProvider - RP name validation
- ✓ validateServiceName - Service name validation
- ✓ getTodayDate - Date formatting

## Safety Features

1. **No Overwrites**: Won't replace existing lease files
2. **Dry Run**: Preview before creating
3. **Validation**: All inputs validated before file creation
4. **Auto-detect**: Repository root automatically found
5. **Error Messages**: Clear, actionable error messages

## Documentation

Three levels of documentation provided:

1. **Built-in Help**: `--help` flag shows usage
2. **README**: Complete reference documentation
3. **EXAMPLES**: 10 practical examples and workflows

## Benefits

1. **Efficiency**: Single reviewer name for all leases
2. **Accuracy**: Validates all inputs before creation
3. **Flexibility**: Multiple input modes (file, single, interactive)
4. **Safety**: Dry-run mode and no overwrites
5. **Integration**: Works seamlessly with fetch-resource-providers.js
6. **Maintainability**: Well-tested and documented

## Future Enhancements (Optional)

Possible future improvements:
- Support for updating existing lease files
- Batch operations with different reviewers
- Export to different formats
- Integration with PR creation workflow
- Automated validation against existing specs

## Testing Performed

1. ✓ Unit tests for all functions
2. ✓ Dry-run tests with various inputs
3. ✓ Manual testing with real file creation
4. ✓ Validation of output format
5. ✓ Integration with fetch-resource-providers.js output format
6. ✓ Error handling for invalid inputs

## Conclusion

The `generate-lease-files.js` script successfully fulfills all requirements:
- Takes input from fetch-resource-providers.js (PR #40116)
- Generates lease.yaml files following PR #39495 structure
- Single reviewer name for all leases
- Comprehensive validation and error handling
- Well-tested and documented
- Ready for production use
