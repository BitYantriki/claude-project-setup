#!/usr/bin/env python3

"""
MCP Test Client
Test and debug MCP servers independently
"""

import asyncio
import json
import sys
import subprocess
from pathlib import Path
from typing import Dict, Any, Optional
import argparse


class MCPTestClient:
    def __init__(self, server_path: str, project_path: str):
        self.server_path = Path(server_path).resolve()
        self.project_path = Path(project_path).resolve()
        self.process = None

    async def start_server(self):
        """Start the MCP server process"""
        self.process = await asyncio.create_subprocess_exec(
            'node', str(self.server_path), str(self.project_path),
            stdin=asyncio.subprocess.PIPE,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        print(f"✅ Started MCP server for: {self.project_path}")

    async def send_request(self, method: str, params: Dict[str, Any] = None) -> Dict[str, Any]:
        """Send JSON-RPC request to server"""
        if not self.process:
            raise RuntimeError("Server not started")

        request = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": method,
            "params": params or {}
        }

        request_json = json.dumps(request) + '\n'
        self.process.stdin.write(request_json.encode())
        await self.process.stdin.drain()

        # Read response
        response_data = await self.process.stdout.readline()
        if not response_data:
            raise RuntimeError("No response from server")

        response = json.loads(response_data.decode())

        if "error" in response:
            raise RuntimeError(f"Server error: {response['error']}")

        return response.get("result", {})

    async def test_tools_list(self):
        """Test listing available tools"""
        print("\n📋 Testing tools/list...")
        result = await self.send_request("tools/list")
        tools = result.get("tools", [])

        print(f"Found {len(tools)} tools:")
        for tool in tools:
            print(f"  - {tool['name']}: {tool['description']}")

        return tools

    async def test_read_file(self, file_path: str):
        """Test reading a file"""
        print(f"\n📖 Testing read_file: {file_path}")
        try:
            result = await self.send_request("tools/call", {
                "name": "read_file",
                "arguments": {"path": file_path}
            })

            content = result['content'][0]['text']
            print(f"File content ({len(content)} chars):")
            print("-" * 40)
            print(content[:500] + "..." if len(content) > 500 else content)
            print("-" * 40)

        except Exception as e:
            print(f"❌ Error: {e}")

    async def test_project_structure(self):
        """Test getting project structure"""
        print("\n🌳 Testing project_structure...")
        try:
            result = await self.send_request("tools/call", {
                "name": "project_structure",
                "arguments": {"maxDepth": 3}
            })

            structure = result['content'][0]['text']
            print("Project structure:")
            print(structure)

        except Exception as e:
            print(f"❌ Error: {e}")

    async def test_list_files(self, directory: str = "."):
        """Test listing files"""
        print(f"\n📁 Testing list_files in: {directory}")
        try:
            result = await self.send_request("tools/call", {
                "name": "list_files",
                "arguments": {"directory": directory}
            })

            files = result['content'][0]['text'].split('\n')
            print(f"Found {len(files)} files:")
            for file in files[:10]:  # Show first 10
                print(f"  - {file}")
            if len(files) > 10:
                print(f"  ... and {len(files) - 10} more")

        except Exception as e:
            print(f"❌ Error: {e}")

    async def test_git_status(self):
        """Test git status"""
        print("\n🔧 Testing git_status...")
        try:
            result = await self.send_request("tools/call", {
                "name": "git_status",
                "arguments": {}
            })

            status = result['content'][0]['text']
            print(status)

        except Exception as e:
            print(f"❌ Error: {e}")

    async def interactive_test(self):
        """Run interactive test session"""
        print("\n🚀 MCP Test Client - Interactive Mode")
        print("=" * 50)
        print("Commands:")
        print("  list - List available tools")
        print("  read <file> - Read a file")
        print("  structure - Show project structure")
        print("  files [dir] - List files in directory")
        print("  git - Show git status")
        print("  call <tool> <json_args> - Call any tool")
        print("  quit - Exit")
        print()

        while True:
            try:
                command = input("mcp-test> ").strip()

                if command == "quit":
                    break
                elif command == "list":
                    await self.test_tools_list()
                elif command.startswith("read "):
                    file_path = command[5:].strip()
                    await self.test_read_file(file_path)
                elif command == "structure":
                    await self.test_project_structure()
                elif command.startswith("files"):
                    parts = command.split()
                    directory = parts[1] if len(parts) > 1 else "."
                    await self.test_list_files(directory)
                elif command == "git":
                    await self.test_git_status()
                elif command.startswith("call "):
                    parts = command[5:].split(" ", 1)
                    if len(parts) == 2:
                        tool_name = parts[0]
                        try:
                            args = json.loads(parts[1])
                        except:
                            args = {}

                        result = await self.send_request("tools/call", {
                            "name": tool_name,
                            "arguments": args
                        })
                        print(json.dumps(result, indent=2))
                    else:
                        print("Usage: call <tool_name> <json_args>")
                else:
                    print("Unknown command. Type 'quit' to exit.")

            except KeyboardInterrupt:
                print("\nUse 'quit' to exit")
            except Exception as e:
                print(f"Error: {e}")

    async def run_tests(self):
        """Run all automated tests"""
        print("🧪 Running MCP Server Tests")
        print("=" * 50)

        await self.start_server()

        # Run test suite
        await self.test_tools_list()
        await self.test_project_structure()
        await self.test_list_files()
        await self.test_git_status()

        # Try to read a file if any exist
        try:
            result = await self.send_request("tools/call", {
                "name": "list_files",
                "arguments": {"directory": "."}
            })
            files = result['content'][0]['text'].split('\n')
            if files and files[0]:
                await self.test_read_file(files[0])
        except:
            pass

        print("\n✅ All tests completed!")

    async def cleanup(self):
        """Clean up resources"""
        if self.process:
            self.process.terminate()
            await self.process.wait()


async def main():
    parser = argparse.ArgumentParser(description='MCP Test Client')
    parser.add_argument('server_path', help='Path to MCP server script')
    parser.add_argument('project_path', nargs='?', default='.',
                        help='Path to project (default: current directory)')
    parser.add_argument('--interactive', '-i', action='store_true',
                        help='Run in interactive mode')

    args = parser.parse_args()

    client = MCPTestClient(args.server_path, args.project_path)

    try:
        await client.start_server()

        if args.interactive:
            await client.interactive_test()
        else:
            await client.run_tests()

    except Exception as e:
        print(f"❌ Fatal error: {e}")
        sys.exit(1)
    finally:
        await client.cleanup()


if __name__ == "__main__":
    asyncio.run(main())
