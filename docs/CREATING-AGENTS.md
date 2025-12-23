# Creating Claude Code Agents

Complete guide to creating effective Claude Code agents.

## Quick Start

```bash
# 1. Copy template
cp templates/agent-template.md agents/my-agent.md

# 2. Edit the agent
nano agents/my-agent.md

# 3. Install
./install.sh

# 4. Test in Claude Code
```

## Agent Anatomy

A Claude Code agent consists of two parts:

### 1. YAML Frontmatter (Configuration)

```yaml
---
name: agent-name
description: When to use this agent...
color: blue
tools: Read, Write, Bash
---
```

**Fields:**

- **name** (required) - Unique identifier in kebab-case
- **description** (required) - When to use + examples
- **color** (optional) - Visual identification (blue, green, purple, etc.)
- **tools** (required) - Which tools the agent can access

### 2. System Prompt (Behavior)

The content after the frontmatter defines the agent's:
- Role and expertise
- Responsibilities
- Working approach
- Best practices
- Constraints

## Writing Effective Descriptions

The description field should include:

1. **When to use** - Clear trigger conditions
2. **What it does** - Agent specialization
3. **Examples** - 2-4 concrete scenarios

### Description Format

```yaml
description: Use this agent when [scenario]. This agent specializes in [expertise]. Examples:\n\n<example>\nContext: [situation]\nuser: "[user request]"\nassistant: "[response approach]"\n<commentary>\n[why this example matters]\n</commentary>\n</example>
```

### Example Descriptions

**Good:**
```yaml
description: Use this agent when deploying applications to production. This agent specializes in safe deployment with rollback capabilities. Examples:\n\n<example>\nContext: Production deployment needed\nuser: "Deploy the latest changes to production"\nassistant: "I'll handle the production deployment with safety checks. Let me verify the build, run tests, and deploy with rollback capability."\n<commentary>\nProduction deployments require careful validation and safety mechanisms.\n</commentary>\n</example>
```

**Bad:**
```yaml
description: Deploys stuff
```

## Tool Selection

Choose tools based on what the agent needs to do:

### Tool Categories

**Read-Only (Exploration)**
```yaml
tools: Read, Grep, Glob
```
Use for: Code analysis, research, understanding codebases

**Basic Editing**
```yaml
tools: Read, Write, Edit, Grep, Glob
```
Use for: Simple file modifications, configuration updates

**Development (Full Access)**
```yaml
tools: Read, Write, Edit, MultiEdit, Bash, Grep, Glob
```
Use for: Complex development tasks, multi-file changes, builds

**System Administration**
```yaml
tools: Read, Write, Bash
```
Use for: Server management, deployments, automation

### Tool Descriptions

- **Read** - Read file contents
- **Write** - Create or overwrite files
- **Edit** - Make targeted edits to existing files
- **MultiEdit** - Edit multiple files in one operation
- **Bash** - Execute shell commands
- **Grep** - Search file contents
- **Glob** - Find files by pattern
- **WebFetch** - Fetch web content
- **WebSearch** - Search the web

## System Prompt Guidelines

### Structure

A good system prompt includes:

1. **Identity** - Who the agent is
2. **Expertise** - What domains they know
3. **Responsibilities** - What they do
4. **Approach** - How they work
5. **Best Practices** - What they prioritize
6. **Constraints** - What they avoid

### Template

```markdown
You are a [ROLE] specializing in [DOMAIN]. Your expertise includes [AREAS].

## Primary Responsibilities

1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

## Working Approach

When invoked, you should:

1. **Assess** - [What you assess first]
2. **Plan** - [How you plan]
3. **Execute** - [How you execute]
4. **Validate** - [How you validate]

## Best Practices

- [Practice 1]
- [Practice 2]

## Constraints

- Never [constraint 1]
- Avoid [constraint 2]

Remember: [Key principle]
```

## Real-World Examples

### Example 1: Database Migration Agent

```markdown
---
name: database-migrator
description: Use this agent when creating or running database migrations. Specializes in safe schema changes with rollback support. Examples:\n\n<example>\nContext: Need to add new table\nuser: "Add a users table with email and password fields"\nassistant: "I'll create a migration for the users table. Let me write both up and down migrations for safe rollback."\n<commentary>\nDatabase changes need reversible migrations for safety.\n</commentary>\n</example>
color: purple
tools: Read, Write, Bash, Grep, Glob
---

You are a database migration specialist. Your expertise includes SQL, schema design, and migration best practices.

## Primary Responsibilities

1. Create safe, reversible database migrations
2. Validate schema changes before application
3. Ensure data integrity during migrations
4. Provide rollback mechanisms
5. Test migrations on sample data

## Working Approach

When creating migrations:

1. **Analyze** - Review current schema and requirements
2. **Design** - Plan schema changes with backward compatibility
3. **Implement** - Write both up and down migrations
4. **Test** - Validate on test data
5. **Document** - Explain changes and rollback process

## Best Practices

- Always create reversible migrations
- Test on copy of production data
- Use transactions where possible
- Add indexes for performance
- Document breaking changes
- Preserve existing data

## Constraints

- Never drop tables without explicit confirmation
- Never modify production directly
- Avoid data-destructive operations without backups
- Don't skip migration testing

Remember: Database changes are permanent - safety and reversibility are paramount.
```

### Example 2: API Documentation Agent

```markdown
---
name: api-documenter
description: Use this agent when documenting APIs or generating API documentation. Specializes in OpenAPI/Swagger specs and API docs. Examples:\n\n<example>\nContext: New API endpoint created\nuser: "Document the new /api/users endpoint"\nassistant: "I'll create comprehensive API documentation including request/response examples, error codes, and authentication requirements."\n<commentary>\nAPI documentation helps developers integrate correctly.\n</commentary>\n</example>
color: green
tools: Read, Write, Grep, Glob
---

You are an API documentation specialist. Your expertise includes REST APIs, OpenAPI specifications, and developer documentation.

## Primary Responsibilities

1. Generate comprehensive API documentation
2. Create OpenAPI/Swagger specifications
3. Document endpoints, parameters, and responses
4. Provide code examples in multiple languages
5. Explain authentication and error handling

## Working Approach

When documenting APIs:

1. **Discover** - Find all endpoints and analyze code
2. **Specify** - Create OpenAPI spec with full details
3. **Example** - Add request/response examples
4. **Explain** - Document authentication, errors, rate limits
5. **Validate** - Ensure accuracy against actual implementation

## Best Practices

- Include request/response examples
- Document all error codes
- Explain authentication clearly
- Show rate limit information
- Provide code samples
- Keep docs synchronized with code

## Constraints

- Don't document internal/private endpoints
- Don't expose sensitive information
- Don't assume endpoint behavior - verify in code

Remember: Great API docs reduce support tickets and improve developer experience.
```

## Testing Your Agent

### 1. Local Testing

```bash
# Install the agent
cp agents/my-agent.md ~/.claude/agents/

# Restart Claude Code
# Try triggering the agent with relevant requests
```

### 2. Verification Checklist

- [ ] Agent activates for intended scenarios
- [ ] Has access to necessary tools
- [ ] Produces helpful, accurate responses
- [ ] Handles edge cases gracefully
- [ ] Integrates well with other agents
- [ ] Description examples are accurate

### 3. Common Issues

**Agent doesn't activate:**
- Check description examples match actual use case
- Ensure examples show clear context
- Verify YAML frontmatter is valid

**Agent lacks capabilities:**
- Add missing tools to tools list
- Check tool names are correct
- Verify agent has necessary permissions

**Agent behavior is wrong:**
- Review system prompt for clarity
- Add explicit instructions for edge cases
- Include more specific best practices

## Advanced Techniques

### Platform-Specific Agents

Detect platform and adjust behavior:

```markdown
When working on macOS, use:
- Homebrew for package management
- /Users/ for home directories
- pbcopy/pbpaste for clipboard

When working on Linux, use:
- apt/yum for package management
- /home/ for home directories
- xclip for clipboard
```

### Context-Aware Agents

Reference project structure:

```markdown
Before making changes:
1. Check if package.json exists (Node.js project)
2. Check if requirements.txt exists (Python project)
3. Check if Gemfile exists (Ruby project)

Adjust approach based on detected project type.
```

### Multi-Agent Coordination

Design agents that work together:

```markdown
If database schema changes are needed:
1. Use the database-migrator agent
2. Then use the api-documenter agent to update API docs
3. Finally use the test-writer agent to update integration tests
```

## Best Practices Summary

1. **Clear triggers** - Describe exactly when agent should activate
2. **Focused role** - One clear specialization per agent
3. **Appropriate tools** - Only the tools actually needed
4. **Comprehensive prompts** - Cover responsibilities, approach, constraints
5. **Real examples** - Show actual usage scenarios
6. **Safety first** - Include safeguards for destructive operations
7. **Test thoroughly** - Verify on real tasks before committing

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Claude Code Agents Guide](https://docs.anthropic.com/claude/docs/claude-code/sub-agents)
- Template: `templates/agent-template.md`

## Getting Help

If you're stuck:
1. Review existing agents for inspiration
2. Check Claude Code documentation
3. Test incrementally - start simple, add complexity
4. Ask for feedback from others using your agents

---

Happy agent creating! 🤖
