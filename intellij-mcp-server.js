#!/usr/bin/env node

/**
 * IntelliJ MCP Server
 * Provides MCP tools for interacting with IntelliJ projects
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import fs from 'fs/promises';
import path from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

class IntelliJMCPServer {
    constructor(projectPath) {
        this.projectPath = path.resolve(projectPath);
        this.server = new Server(
            {
                name: 'intellij-mcp-server',
                version: '1.0.0',
            },
            {
                capabilities: {
                    tools: {},
                    resources: {},
                },
            }
        );
        
        this.setupHandlers();
    }

    setupHandlers() {
        // List available tools
        this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
            tools: [
                {
                    name: 'read_file',
                    description: 'Read the contents of a file',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            path: { type: 'string', description: 'File path relative to project root' }
                        },
                        required: ['path']
                    }
                },
                {
                    name: 'write_file',
                    description: 'Write content to a file',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            path: { type: 'string', description: 'File path relative to project root' },
                            content: { type: 'string', description: 'Content to write' }
                        },
                        required: ['path', 'content']
                    }
                },
                {
                    name: 'list_files',
                    description: 'List files in a directory',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            directory: { type: 'string', description: 'Directory path relative to project root' },
                            pattern: { type: 'string', description: 'File pattern (e.g., *.java)' }
                        }
                    }
                },
                {
                    name: 'execute_command',
                    description: 'Execute a command in the project directory',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            command: { type: 'string', description: 'Command to execute' }
                        },
                        required: ['command']
                    }
                },
                {
                    name: 'project_structure',
                    description: 'Get the project structure',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            maxDepth: { type: 'number', description: 'Maximum depth to traverse' }
                        }
                    }
                },
                {
                    name: 'git_status',
                    description: 'Get git status of the project',
                    inputSchema: { type: 'object', properties: {} }
                },
                {
                    name: 'find_class',
                    description: 'Find Java/Kotlin classes by name',
                    inputSchema: {
                        type: 'object',
                        properties: {
                            className: { type: 'string', description: 'Class name to search for' }
                        },
                        required: ['className']
                    }
                }
            ]
        }));

        // Handle tool calls
        this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
            const { name, arguments: args } = request.params;

            try {
                switch (name) {
                    case 'read_file':
                        return await this.readFile(args.path);
                    case 'write_file':
                        return await this.writeFile(args.path, args.content);
                    case 'list_files':
                        return await this.listFiles(args.directory || '.', args.pattern);
                    case 'execute_command':
                        return await this.executeCommand(args.command);
                    case 'project_structure':
                        return await this.getProjectStructure(args.maxDepth || 3);
                    case 'git_status':
                        return await this.getGitStatus();
                    case 'find_class':
                        return await this.findClass(args.className);
                    default:
                        throw new Error(`Unknown tool: ${name}`);
                }
            } catch (error) {
                return {
                    content: [{ type: 'text', text: `Error: ${error.message}` }]
                };
            }
        });
    }

    async readFile(filePath) {
        const fullPath = path.join(this.projectPath, filePath);
        const content = await fs.readFile(fullPath, 'utf-8');
        return {
            content: [{ type: 'text', text: content }]
        };
    }

    async writeFile(filePath, content) {
        const fullPath = path.join(this.projectPath, filePath);
        await fs.mkdir(path.dirname(fullPath), { recursive: true });
        await fs.writeFile(fullPath, content, 'utf-8');
        return {
            content: [{ type: 'text', text: `File written successfully: ${filePath}` }]
        };
    }

    async listFiles(directory, pattern) {
        const fullPath = path.join(this.projectPath, directory);
        const files = await this.walkDirectory(fullPath, pattern);
        return {
            content: [{ type: 'text', text: files.join('\n') }]
        };
    }

    async walkDirectory(dir, pattern) {
        const files = [];
        const entries = await fs.readdir(dir, { withFileTypes: true });
        
        for (const entry of entries) {
            const fullPath = path.join(dir, entry.name);
            const relativePath = path.relative(this.projectPath, fullPath);
            
            if (entry.isDirectory() && !entry.name.startsWith('.')) {
                files.push(...await this.walkDirectory(fullPath, pattern));
            } else if (entry.isFile()) {
                if (!pattern || entry.name.match(pattern)) {
                    files.push(relativePath);
                }
            }
        }
        
        return files;
    }

    async executeCommand(command) {
        try {
            const { stdout, stderr } = await execAsync(command, { cwd: this.projectPath });
            return {
                content: [{ 
                    type: 'text', 
                    text: `Command: ${command}\n\nOutput:\n${stdout}\n${stderr ? `\nErrors:\n${stderr}` : ''}` 
                }]
            };
        } catch (error) {
            return {
                content: [{ type: 'text', text: `Command failed: ${error.message}` }]
            };
        }
    }

    async getProjectStructure(maxDepth) {
        const structure = await this.buildProjectTree(this.projectPath, 0, maxDepth);
        return {
            content: [{ type: 'text', text: this.formatTree(structure) }]
        };
    }

    async buildProjectTree(dir, depth, maxDepth) {
        if (depth > maxDepth) return null;
        
        const name = path.basename(dir);
        const stats = await fs.stat(dir);
        
        if (!stats.isDirectory()) {
            return { name, type: 'file' };
        }
        
        const children = [];
        const entries = await fs.readdir(dir);
        
        for (const entry of entries) {
            if (entry.startsWith('.')) continue;
            
            const childPath = path.join(dir, entry);
            const child = await this.buildProjectTree(childPath, depth + 1, maxDepth);
            if (child) children.push(child);
        }
        
        return { name, type: 'directory', children };
    }

    formatTree(node, prefix = '', isLast = true) {
        let result = prefix + (isLast ? '└── ' : '├── ') + node.name + '\n';
        
        if (node.children) {
            const childPrefix = prefix + (isLast ? '    ' : '│   ');
            node.children.forEach((child, index) => {
                result += this.formatTree(child, childPrefix, index === node.children.length - 1);
            });
        }
        
        return result;
    }

    async getGitStatus() {
        try {
            const { stdout } = await execAsync('git status --porcelain', { cwd: this.projectPath });
            const status = stdout || 'Working directory clean';
            return {
                content: [{ type: 'text', text: `Git Status:\n${status}` }]
            };
        } catch (error) {
            return {
                content: [{ type: 'text', text: 'Not a git repository or git not installed' }]
            };
        }
    }

    async findClass(className) {
        const javaFiles = await this.walkDirectory(this.projectPath, /\.(java|kt)$/);
        const matches = [];
        
        for (const file of javaFiles) {
            const content = await fs.readFile(path.join(this.projectPath, file), 'utf-8');
            if (content.includes(`class ${className}`) || content.includes(`interface ${className}`)) {
                matches.push(file);
            }
        }
        
        return {
            content: [{ 
                type: 'text', 
                text: matches.length > 0 
                    ? `Found ${className} in:\n${matches.join('\n')}` 
                    : `No classes found matching: ${className}`
            }]
        };
    }

    async run() {
        const transport = new StdioServerTransport();
        await this.server.connect(transport);
        console.error(`IntelliJ MCP Server running for project: ${this.projectPath}`);
    }
}

// Start server
const projectPath = process.argv[2] || '.';
const server = new IntelliJMCPServer(projectPath);
server.run().catch(console.error);
