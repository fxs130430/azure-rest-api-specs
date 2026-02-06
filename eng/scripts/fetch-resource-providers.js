#!/usr/bin/env node
/**
 * Fetch Azure resource providers with or without service groups.
 * 
 * Usage:
 *   node fetch-resource-providers.js [--with-service-groups] [--format FORMAT] [--count]
 * 
 * Options:
 *   --with-service-groups  Show RPs with service groups (default: without)
 *   --format FORMAT        Output format: list, json, table (default: list)
 *   --count               Show only count
 *   --repo-root PATH      Repository root (default: auto-detect)
 */

const fs = require('fs');
const path = require('path');

/**
 * Check if directory is a service group (not stable/preview/common-types/examples).
 */
function isServiceGroupDirectory(dirPath) {
    const excludeNames = new Set(['stable', 'preview', 'common-types', 'examples']);
    const name = path.basename(dirPath);
    try {
        return !excludeNames.has(name) && fs.statSync(dirPath).isDirectory();
    } catch {
        return false;
    }
}

/**
 * Check if resource provider has stable or preview directories.
 */
function hasVersionDirectories(rpPath) {
    return fs.existsSync(path.join(rpPath, 'stable')) || 
           fs.existsSync(path.join(rpPath, 'preview'));
}

/**
 * Find repository root by searching for specification directory.
 */
function findRepoRoot(startPath = null) {
    let current = path.resolve(startPath || process.cwd());
    
    for (let i = 0; i < 6; i++) {
        const specPath = path.join(current, 'specification');
        if (fs.existsSync(specPath) && fs.statSync(specPath).isDirectory()) {
            return current;
        }
        
        const parent = path.dirname(current);
        if (parent === current) {
            break;
        }
        current = parent;
    }
    
    throw new Error(
        `Could not find azure-rest-api-specs repository root from ${startPath || process.cwd()}. ` +
        `Make sure you're running this script from within the repository.`
    );
}

/**
 * Find resource providers with or without service groups.
 */
function findResourceProviders(repoRoot, withServiceGroups = false) {
    const resourceProviders = [];
    const specDir = path.join(repoRoot, 'specification');
    
    if (!fs.existsSync(specDir)) {
        throw new Error(`Specification directory not found: ${specDir}`);
    }
    
    const serviceDirs = fs.readdirSync(specDir);
    
    for (const serviceDirName of serviceDirs) {
        const serviceDir = path.join(specDir, serviceDirName);
        
        if (!fs.statSync(serviceDir).isDirectory()) {
            continue;
        }
        
        const resourceManagerDir = path.join(serviceDir, 'resource-manager');
        if (!fs.existsSync(resourceManagerDir)) {
            continue;
        }
        
        const items = fs.readdirSync(resourceManagerDir);
        
        for (const itemName of items) {
            const item = path.join(resourceManagerDir, itemName);
            
            if (!fs.statSync(item).isDirectory() || !itemName.startsWith('Microsoft.')) {
                continue;
            }
            
            const serviceGroups = [];
            const subItems = fs.readdirSync(item);
            
            for (const subItem of subItems) {
                const subItemPath = path.join(item, subItem);
                if (isServiceGroupDirectory(subItemPath)) {
                    serviceGroups.push(subItem);
                }
            }
            
            const relativePath = path.relative(repoRoot, item);
            
            if (withServiceGroups && serviceGroups.length > 0) {
                resourceProviders.push({
                    name: itemName,
                    path: relativePath,
                    service: serviceDirName,
                    service_groups: serviceGroups.sort()
                });
            } else if (!withServiceGroups && serviceGroups.length === 0 && hasVersionDirectories(item)) {
                resourceProviders.push({
                    name: itemName,
                    path: relativePath,
                    service: serviceDirName
                });
            }
        }
    }
    
    resourceProviders.sort((a, b) => a.name.localeCompare(b.name));
    return resourceProviders;
}

/**
 * Format resource provider list according to specified format.
 */
function formatOutput(resourceProviders, formatType, withServiceGroups) {
    if (formatType === 'json') {
        return JSON.stringify(resourceProviders, null, 2);
    }
    
    if (resourceProviders.length === 0) {
        const msg = withServiceGroups ? "with" : "without";
        return `No resource providers ${msg} service groups found.`;
    }
    
    if (formatType === 'table') {
        if (withServiceGroups) {
            const maxServiceLen = Math.max(...resourceProviders.map(rp => rp.service.length));
            const maxNameLen = Math.max(...resourceProviders.map(rp => rp.name.length));
            const header = `${'Service'.padEnd(maxServiceLen)}  ${'Resource Provider'.padEnd(maxNameLen)}  Service Groups`;
            const separator = `${'-'.repeat(maxServiceLen)}  ${'-'.repeat(maxNameLen)}  ${'-'.repeat(60)}`;
            const rows = resourceProviders.map(rp => 
                `${rp.service.padEnd(maxServiceLen)}  ${rp.name.padEnd(maxNameLen)}  ${rp.service_groups.join(', ')}`
            );
            return [header, separator, ...rows].join('\n');
        } else {
            const maxServiceLen = Math.max(...resourceProviders.map(rp => rp.service.length));
            const maxNameLen = Math.max(...resourceProviders.map(rp => rp.name.length));
            const header = `${'Service'.padEnd(maxServiceLen)}  ${'Resource Provider'.padEnd(maxNameLen)}  Path`;
            const separator = `${'-'.repeat(maxServiceLen)}  ${'-'.repeat(maxNameLen)}  ${'-'.repeat(50)}`;
            const rows = resourceProviders.map(rp => 
                `${rp.service.padEnd(maxServiceLen)}  ${rp.name.padEnd(maxNameLen)}  ${rp.path}`
            );
            return [header, separator, ...rows].join('\n');
        }
    }
    
    // list format
    if (withServiceGroups) {
        return resourceProviders
            .map(rp => `${rp.service}, ${rp.name}, [${rp.service_groups.join(', ')}]`)
            .join('\n');
    } else {
        return resourceProviders
            .map(rp => `${rp.service}, ${rp.name}`)
            .join('\n');
    }
}

/**
 * Parse command line arguments.
 */
function parseArgs() {
    const args = {
        repoRoot: null,
        format: 'list',
        count: false,
        withServiceGroups: false,
        help: false
    };
    
    for (let i = 2; i < process.argv.length; i++) {
        const arg = process.argv[i];
        
        if (arg === '--help' || arg === '-h') {
            args.help = true;
        } else if (arg === '--repo-root') {
            args.repoRoot = process.argv[++i];
        } else if (arg === '--format') {
            args.format = process.argv[++i];
            if (!['list', 'json', 'table'].includes(args.format)) {
                throw new Error(`Invalid format: ${args.format}. Must be one of: list, json, table`);
            }
        } else if (arg === '--count') {
            args.count = true;
        } else if (arg === '--with-service-groups') {
            args.withServiceGroups = true;
        } else {
            throw new Error(`Unknown argument: ${arg}`);
        }
    }
    
    return args;
}

/**
 * Show help message.
 */
function showHelp() {
    console.log(`
Fetch Azure resource providers with or without service groups.

Usage:
  node fetch-resource-providers.js [OPTIONS]

Options:
  --with-service-groups  Show RPs with service groups (default: without)
  --format FORMAT        Output format: list, json, table (default: list)
  --count               Show only count
  --repo-root PATH      Repository root (default: auto-detect)
  --help, -h            Show this help message
`);
}

/**
 * Main entry point.
 */
function main() {
    try {
        const args = parseArgs();
        
        if (args.help) {
            showHelp();
            return 0;
        }
        
        const repoRoot = args.repoRoot ? path.resolve(args.repoRoot) : findRepoRoot();
        const resourceProviders = findResourceProviders(repoRoot, args.withServiceGroups);
        
        if (args.count) {
            console.log(resourceProviders.length);
        } else {
            const output = formatOutput(resourceProviders, args.format, args.withServiceGroups);
            console.log(output);
            
            if (args.format !== 'json') {
                const msg = args.withServiceGroups ? "with" : "without";
                console.log(`\nTotal: ${resourceProviders.length} resource provider(s) ${msg} service groups`);
            }
        }
        
        return 0;
    } catch (error) {
        console.error(`Error: ${error.message}`);
        return 1;
    }
}

if (require.main === module) {
    process.exit(main());
}

module.exports = {
    findRepoRoot,
    findResourceProviders,
    formatOutput,
    isServiceGroupDirectory,
    hasVersionDirectories
};
