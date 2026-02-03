#!/usr/bin/env python3
"""
Simple test script for fetch_rp_without_service_groups.py

Tests basic functionality to ensure the script works correctly.
"""

import json
import subprocess
import sys
from pathlib import Path


def run_script(*args):
    """Run the fetch_rp_without_service_groups.py script with given arguments."""
    script_path = Path(__file__).parent / 'fetch_rp_without_service_groups.py'
    repo_root = Path(__file__).parent.parent.parent
    
    cmd = [sys.executable, str(script_path), '--repo-root', str(repo_root)] + list(args)
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result


def test_count_output():
    """Test that --count returns a number."""
    result = run_script('--count')
    assert result.returncode == 0, f"Script failed: {result.stderr}"
    
    count = int(result.stdout.strip())
    assert count > 0, "Count should be greater than 0"
    print(f"✓ Count test passed: Found {count} resource providers")
    return count


def test_list_format():
    """Test list format output."""
    result = run_script('--format', 'list')
    assert result.returncode == 0, f"Script failed: {result.stderr}"
    
    lines = result.stdout.strip().split('\n')
    # Filter out summary line
    provider_lines = [l for l in lines if l and not l.startswith('Total:')]
    
    # Check at least one provider is listed
    assert len(provider_lines) > 0, "Should have at least one resource provider"
    
    # Check format (should be "Microsoft.XXX (service)")
    for line in provider_lines[:5]:  # Check first 5
        if '(' in line and ')' in line:
            assert line.startswith('Microsoft.'), f"Invalid format: {line}"
    
    print(f"✓ List format test passed: {len(provider_lines)} providers listed")
    return len(provider_lines)


def test_json_format():
    """Test JSON format output."""
    result = run_script('--format', 'json')
    assert result.returncode == 0, f"Script failed: {result.stderr}"
    
    # Parse JSON
    data = json.loads(result.stdout)
    
    # Check structure
    assert isinstance(data, list), "JSON output should be a list"
    assert len(data) > 0, "Should have at least one entry"
    
    # Check first entry structure
    first = data[0]
    assert 'name' in first, "Entry should have 'name' field"
    assert 'path' in first, "Entry should have 'path' field"
    assert 'service' in first, "Entry should have 'service' field"
    assert first['name'].startswith('Microsoft.'), "Name should start with 'Microsoft.'"
    
    print(f"✓ JSON format test passed: {len(data)} providers in JSON")
    return len(data)


def test_table_format():
    """Test table format output."""
    result = run_script('--format', 'table')
    assert result.returncode == 0, f"Script failed: {result.stderr}"
    
    lines = result.stdout.strip().split('\n')
    # Should have header, separator, and data rows
    assert len(lines) >= 3, "Table should have header, separator, and at least one row"
    
    # Check header
    assert 'Resource Provider' in lines[0], "Header should contain 'Resource Provider'"
    assert 'Service' in lines[0], "Header should contain 'Service'"
    assert 'Path' in lines[0], "Header should contain 'Path'"
    
    print(f"✓ Table format test passed: {len(lines) - 3} providers in table")


def test_known_providers():
    """Test that known providers are correctly identified."""
    result = run_script('--format', 'json')
    assert result.returncode == 0, f"Script failed: {result.stderr}"
    
    data = json.loads(result.stdout)
    provider_names = [item['name'] for item in data]
    
    # Storage should NOT have service groups
    assert 'Microsoft.Storage' in provider_names, "Microsoft.Storage should be in the list"
    
    # KeyVault should NOT have service groups
    assert 'Microsoft.KeyVault' in provider_names, "Microsoft.KeyVault should be in the list"
    
    # Compute has service groups (CloudserviceRP, ComputeRP, etc.), so should NOT be in list
    assert 'Microsoft.Compute' not in provider_names, "Microsoft.Compute should NOT be in the list"
    
    print("✓ Known providers test passed")


def main():
    """Run all tests."""
    print("Running tests for fetch_rp_without_service_groups.py...\n")
    
    try:
        count = test_count_output()
        list_count = test_list_format()
        json_count = test_json_format()
        test_table_format()
        test_known_providers()
        
        # Verify all formats return same count
        assert count == list_count == json_count, \
            f"Count mismatch: count={count}, list={list_count}, json={json_count}"
        
        print("\n✅ All tests passed!")
        return 0
        
    except AssertionError as e:
        print(f"\n❌ Test failed: {e}")
        return 1
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
