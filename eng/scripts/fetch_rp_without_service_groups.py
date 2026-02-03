#!/usr/bin/env python3
"""
Script to fetch list of resource providers with or without service groups.

This script identifies Azure resource providers under the specification directory
based on whether they use service groups for organization.

WHAT IT DOES:
-------------
Scans the Azure REST API specifications repository to find resource providers
and categorizes them based on service group usage.

Example structure differences:
- Microsoft.Compute (HAS service groups): CloudserviceRP/, ComputeRP/, DiskRP/
- Microsoft.Storage (NO service groups): stable/, preview/ (directly)

HOW TO RUN:
-----------
The script automatically detects the repository root. Run from anywhere in the repo:

    # List all resource providers WITHOUT service groups (default)
    python fetch_rp_without_service_groups.py

    # List all resource providers WITH service groups
    python fetch_rp_without_service_groups.py --with-service-groups

    # Get just the count
    python fetch_rp_without_service_groups.py --count
    python fetch_rp_without_service_groups.py --with-service-groups --count

    # Output as table
    python fetch_rp_without_service_groups.py --format table
    python fetch_rp_without_service_groups.py --with-service-groups --format table

    # Output as JSON
    python fetch_rp_without_service_groups.py --format json
    python fetch_rp_without_service_groups.py --with-service-groups --format json

    # Specify repository root explicitly (if running from outside repo)
    python fetch_rp_without_service_groups.py --repo-root /path/to/azure-rest-api-specs

ARGUMENTS:
----------
    --repo-root PATH         Path to azure-rest-api-specs repository root
                             (default: auto-detects from current location)
    --format FORMAT          Output format: 'list', 'json', or 'table' (default: 'list')
    --count                  Show only the count of resource providers
    --with-service-groups    Show resource providers WITH service groups (instead of without)
    --help                   Show this help message

OUTPUT FORMATS:
---------------
Without --with-service-groups flag:
    list    - Simple list of resource provider names
              Example: Microsoft.Storage
    
    table   - Formatted table with columns for name, service, and path
    
    json    - JSON array with full details (name, path, service)

With --with-service-groups flag:
    list    - Resource provider name with its service groups
              Example: Microsoft.Compute: [CloudserviceRP, ComputeRP, DiskRP, ...]
    
    table   - Formatted table with resource provider and service groups columns
    
    json    - JSON array with full details including service_groups array

EXAMPLES:
---------
    # Show RPs without service groups
    cd /path/to/azure-rest-api-specs
    python eng/scripts/fetch_rp_without_service_groups.py

    # Show RPs with service groups
    python eng/scripts/fetch_rp_without_service_groups.py --with-service-groups

    # Show RPs with service groups as JSON
    python eng/scripts/fetch_rp_without_service_groups.py --with-service-groups --format json

    # From any subdirectory (auto-detects repo root)
    cd /path/to/azure-rest-api-specs/specification/compute
    python ../../eng/scripts/fetch_rp_without_service_groups.py --with-service-groups --count

TESTING:
--------
Run the test suite to verify functionality:
    python Tests/test_fetch_rp.py
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import List, Dict


def is_service_group_directory(path: Path) -> bool:
    """
    Determine if a directory is a service group directory.
    
    Service groups are subdirectories under a resource provider that are not:
    - 'stable' or 'preview' (version directories)
    - 'common-types' (shared definitions)
    - 'examples' (example files)
    """
    exclude_names = {'stable', 'preview', 'common-types', 'examples'}
    return path.name not in exclude_names and path.is_dir()


def has_version_directories(rp_path: Path) -> bool:
    """Check if the resource provider has stable or preview directories."""
    return (rp_path / 'stable').exists() or (rp_path / 'preview').exists()


def find_repo_root(start_path: Path = None) -> Path:
    """
    Find the repository root by looking for the specification directory.
    
    Searches upward from the start_path to find a directory containing 'specification'.
    
    Args:
        start_path: Starting directory (default: current working directory)
    
    Returns:
        Path to the repository root
        
    Raises:
        FileNotFoundError: If repository root cannot be found
    """
    if start_path is None:
        start_path = Path.cwd()
    
    current = start_path.resolve()
    
    # Check current directory and up to 5 parent directories
    for _ in range(6):
        if (current / 'specification').exists() and (current / 'specification').is_dir():
            return current
        
        # Move to parent directory
        parent = current.parent
        if parent == current:  # Reached filesystem root
            break
        current = parent
    
    raise FileNotFoundError(
        f"Could not find azure-rest-api-specs repository root from {start_path}. "
        f"Make sure you're running this script from within the repository."
    )


def find_resource_providers_without_service_groups(repo_root: Path) -> List[Dict[str, str]]:
    """
    Find all resource providers that have no service groups.
    
    Returns:
        List of dictionaries containing resource provider information:
        - 'name': Resource provider name (e.g., 'Microsoft.Storage')
        - 'path': Relative path from repo root
        - 'service': Service name (parent directory name)
    """
    resource_providers = []
    spec_dir = repo_root / 'specification'
    
    if not spec_dir.exists():
        raise FileNotFoundError(f"Specification directory not found: {spec_dir}")
    
    # Iterate through all service directories
    for service_dir in spec_dir.iterdir():
        if not service_dir.is_dir():
            continue
            
        resource_manager_dir = service_dir / 'resource-manager'
        if not resource_manager_dir.exists():
            continue
        
        # Find all Microsoft.* resource provider directories
        for item in resource_manager_dir.iterdir():
            if not item.is_dir() or not item.name.startswith('Microsoft.'):
                continue
            
            # Check if this resource provider has service groups
            service_groups = [
                d for d in item.iterdir()
                if is_service_group_directory(d)
            ]
            
            # If no service groups and has version directories, add to list
            if not service_groups and has_version_directories(item):
                relative_path = item.relative_to(repo_root)
                resource_providers.append({
                    'name': item.name,
                    'path': str(relative_path),
                    'service': service_dir.name
                })
    
    # Sort by resource provider name
    resource_providers.sort(key=lambda x: x['name'])
    
    return resource_providers


def find_resource_providers_with_service_groups(repo_root: Path) -> List[Dict[str, any]]:
    """
    Find all resource providers that have service groups.
    
    Returns:
        List of dictionaries containing resource provider information:
        - 'name': Resource provider name (e.g., 'Microsoft.Compute')
        - 'path': Relative path from repo root
        - 'service': Service name (parent directory name)
        - 'service_groups': List of service group names
    """
    resource_providers = []
    spec_dir = repo_root / 'specification'
    
    if not spec_dir.exists():
        raise FileNotFoundError(f"Specification directory not found: {spec_dir}")
    
    # Iterate through all service directories
    for service_dir in spec_dir.iterdir():
        if not service_dir.is_dir():
            continue
            
        resource_manager_dir = service_dir / 'resource-manager'
        if not resource_manager_dir.exists():
            continue
        
        # Find all Microsoft.* resource provider directories
        for item in resource_manager_dir.iterdir():
            if not item.is_dir() or not item.name.startswith('Microsoft.'):
                continue
            
            # Check if this resource provider has service groups
            service_groups = [
                d.name for d in item.iterdir()
                if is_service_group_directory(d)
            ]
            
            # If has service groups, add to list
            if service_groups:
                relative_path = item.relative_to(repo_root)
                resource_providers.append({
                    'name': item.name,
                    'path': str(relative_path),
                    'service': service_dir.name,
                    'service_groups': sorted(service_groups)
                })
    
    # Sort by resource provider name
    resource_providers.sort(key=lambda x: x['name'])
    
    return resource_providers


def format_output(resource_providers: List[Dict[str, str]], format_type: str) -> str:
    """
    Format the resource provider list according to the specified format.
    
    Args:
        resource_providers: List of resource provider dictionaries
        format_type: One of 'list', 'json', or 'table'
    
    Returns:
        Formatted string output
    """
    if format_type == 'json':
        return json.dumps(resource_providers, indent=2)
    
    elif format_type == 'table':
        if not resource_providers:
            return "No resource providers without service groups found."
        
        # Calculate column widths
        max_name_len = max(len(rp['name']) for rp in resource_providers)
        max_service_len = max(len(rp['service']) for rp in resource_providers)
        
        # Create table header
        header = f"{'Resource Provider':<{max_name_len}}  {'Service':<{max_service_len}}  Path"
        separator = f"{'-' * max_name_len}  {'-' * max_service_len}  {'-' * 50}"
        
        # Create table rows
        rows = [
            f"{rp['name']:<{max_name_len}}  {rp['service']:<{max_service_len}}  {rp['path']}"
            for rp in resource_providers
        ]
        
        return '\n'.join([header, separator] + rows)
    
    else:  # format_type == 'list'
        if not resource_providers:
            return "No resource providers without service groups found."
        
        lines = [
            rp['name']
            for rp in resource_providers
        ]
        return '\n'.join(lines)


def format_output_with_service_groups(resource_providers: List[Dict[str, any]], format_type: str) -> str:
    """
    Format the resource provider list with service groups according to the specified format.
    
    Args:
        resource_providers: List of resource provider dictionaries with service_groups
        format_type: One of 'list', 'json', or 'table'
    
    Returns:
        Formatted string output
    """
    if format_type == 'json':
        return json.dumps(resource_providers, indent=2)
    
    elif format_type == 'table':
        if not resource_providers:
            return "No resource providers with service groups found."
        
        # Calculate column widths
        max_name_len = max(len(rp['name']) for rp in resource_providers)
        
        # Create table header
        header = f"{'Resource Provider':<{max_name_len}}  Service Groups"
        separator = f"{'-' * max_name_len}  {'-' * 60}"
        
        # Create table rows
        rows = []
        for rp in resource_providers:
            service_groups_str = ', '.join(rp['service_groups'])
            rows.append(f"{rp['name']:<{max_name_len}}  {service_groups_str}")
        
        return '\n'.join([header, separator] + rows)
    
    else:  # format_type == 'list'
        if not resource_providers:
            return "No resource providers with service groups found."
        
        lines = []
        for rp in resource_providers:
            service_groups_str = ', '.join(rp['service_groups'])
            lines.append(f"{rp['name']}: [{service_groups_str}]")
        
        return '\n'.join(lines)


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description='Fetch list of resource providers with or without service groups',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument(
        '--repo-root',
        type=Path,
        default=None,
        help='Path to the azure-rest-api-specs repository root (default: auto-detect from current location)'
    )
    parser.add_argument(
        '--format',
        choices=['list', 'json', 'table'],
        default='list',
        help="Output format: 'list' (default), 'json', or 'table'"
    )
    parser.add_argument(
        '--count',
        action='store_true',
        help='Only output the count of resource providers found'
    )
    parser.add_argument(
        '--with-service-groups',
        action='store_true',
        help='Show resource providers WITH service groups (instead of without)'
    )
    
    args = parser.parse_args()
    
    try:
        # Determine repository root
        if args.repo_root:
            repo_root = args.repo_root.resolve()
        else:
            # Auto-detect repository root
            repo_root = find_repo_root()
        
        # Find resource providers based on flag
        if args.with_service_groups:
            resource_providers = find_resource_providers_with_service_groups(repo_root)
            msg_suffix = "with service groups"
        else:
            resource_providers = find_resource_providers_without_service_groups(repo_root)
            msg_suffix = "without service groups"
        
        if args.count:
            print(len(resource_providers))
        else:
            # Format and print output
            if args.with_service_groups:
                output = format_output_with_service_groups(resource_providers, args.format)
            else:
                output = format_output(resource_providers, args.format)
            print(output)
            
            # Print summary
            if args.format != 'json':
                print(f"\nTotal: {len(resource_providers)} resource provider(s) {msg_suffix}")
        
        return 0
    
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
