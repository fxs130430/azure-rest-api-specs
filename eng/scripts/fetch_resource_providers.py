#!/usr/bin/env python3
"""
Fetch Azure resource providers with or without service groups.

Usage:
  python fetch_resource_providers.py [--with-service-groups] [--format FORMAT] [--count]

Options:
  --with-service-groups  Show RPs with service groups (default: without)
  --format FORMAT        Output format: list, json, table (default: list)
  --count               Show only count
  --repo-root PATH      Repository root (default: auto-detect)
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List, Dict, Optional


def is_service_group_directory(path: Path) -> bool:
    """Check if directory is a service group (not stable/preview/common-types/examples)."""
    exclude_names = {'stable', 'preview', 'common-types', 'examples'}
    return path.name not in exclude_names and path.is_dir()


def has_version_directories(rp_path: Path) -> bool:
    """Check if resource provider has stable or preview directories."""
    return (rp_path / 'stable').exists() or (rp_path / 'preview').exists()


def find_repo_root(start_path: Optional[Path] = None) -> Path:
    """Find repository root by searching for specification directory."""
    if start_path is None:
        start_path = Path.cwd()
    current = start_path.resolve()
    for _ in range(6):
        if (current / 'specification').exists() and (current / 'specification').is_dir():
            return current
        parent = current.parent
        if parent == current:
            break
        current = parent
    raise FileNotFoundError(
        f"Could not find azure-rest-api-specs repository root from {start_path}. "
        f"Make sure you're running this script from within the repository."
    )


def find_resource_providers(repo_root: Path, with_service_groups: bool = False) -> List[Dict]:
    """Find resource providers with or without service groups."""
    resource_providers = []
    spec_dir = repo_root / 'specification'
    if not spec_dir.exists():
        raise FileNotFoundError(f"Specification directory not found: {spec_dir}")
    
    for service_dir in spec_dir.iterdir():
        if not service_dir.is_dir():
            continue
        resource_manager_dir = service_dir / 'resource-manager'
        if not resource_manager_dir.exists():
            continue
        
        for item in resource_manager_dir.iterdir():
            if not item.is_dir() or not item.name.startswith('Microsoft.'):
                continue
            
            service_groups = [d.name for d in item.iterdir() if is_service_group_directory(d)]
            
            if with_service_groups and service_groups:
                resource_providers.append({
                    'name': item.name,
                    'path': str(item.relative_to(repo_root)),
                    'service': service_dir.name,
                    'service_groups': sorted(service_groups)
                })
            elif not with_service_groups and not service_groups and has_version_directories(item):
                resource_providers.append({
                    'name': item.name,
                    'path': str(item.relative_to(repo_root)),
                    'service': service_dir.name
                })
    
    resource_providers.sort(key=lambda x: x['name'])
    return resource_providers


def format_output(resource_providers: List[Dict], format_type: str, with_service_groups: bool) -> str:
    """Format resource provider list according to specified format."""
    if format_type == 'json':
        return json.dumps(resource_providers, indent=2)
    
    if not resource_providers:
        msg = "with" if with_service_groups else "without"
        return f"No resource providers {msg} service groups found."
    
    if format_type == 'table':
        if with_service_groups:
            max_name_len = max(len(rp['name']) for rp in resource_providers)
            header = f"{'Resource Provider':<{max_name_len}}  Service Groups"
            separator = f"{'-' * max_name_len}  {'-' * 60}"
            rows = [f"{rp['name']:<{max_name_len}}  {', '.join(rp['service_groups'])}"
                   for rp in resource_providers]
        else:
            max_name_len = max(len(rp['name']) for rp in resource_providers)
            max_service_len = max(len(rp['service']) for rp in resource_providers)
            header = f"{'Resource Provider':<{max_name_len}}  {'Service':<{max_service_len}}  Path"
            separator = f"{'-' * max_name_len}  {'-' * max_service_len}  {'-' * 50}"
            rows = [f"{rp['name']:<{max_name_len}}  {rp['service']:<{max_service_len}}  {rp['path']}"
                   for rp in resource_providers]
        return '\n'.join([header, separator] + rows)
    
    else:  # list format
        if with_service_groups:
            return '\n'.join(f"{rp['name']}: [{', '.join(rp['service_groups'])}]"
                           for rp in resource_providers)
        else:
            return '\n'.join(rp['name'] for rp in resource_providers)


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description='Fetch list of resource providers with or without service groups',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument('--repo-root', type=Path, default=None,
                       help='Path to repository root (default: auto-detect)')
    parser.add_argument('--format', choices=['list', 'json', 'table'], default='list',
                       help="Output format (default: list)")
    parser.add_argument('--count', action='store_true',
                       help='Only output the count')
    parser.add_argument('--with-service-groups', action='store_true',
                       help='Show RPs with service groups (default: without)')
    
    args = parser.parse_args()
    
    try:
        repo_root = args.repo_root.resolve() if args.repo_root else find_repo_root()
        resource_providers = find_resource_providers(repo_root, args.with_service_groups)
        
        if args.count:
            print(len(resource_providers))
        else:
            output = format_output(resource_providers, args.format, args.with_service_groups)
            print(output)
            if args.format != 'json':
                msg = "with" if args.with_service_groups else "without"
                print(f"\nTotal: {len(resource_providers)} resource provider(s) {msg} service groups")
        return 0
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())

