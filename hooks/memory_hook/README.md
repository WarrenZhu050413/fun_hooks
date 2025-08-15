# Claude Code Memory Hook 🧠

Give Claude persistent memory across sessions! This hook enables Claude to track project history, remember user preferences, and maintain context over time.

## What It Does

This hook creates a memory system for Claude that:
- 📝 Tracks daily interactions and decisions
- 🔄 Maintains context between sessions  
- 📊 Identifies patterns in your workflow
- 💡 Builds long-term knowledge about your project
- 🎯 Provides personalized assistance based on history

## Components

### 1. The Hook (`memory-hook.sh`)
- Injects memory context into each prompt
- Auto-detects projects with memory enabled
- Lightweight bash script with no dependencies

### 2. Memory Configuration (`CLAUDE.md.template`)
**IMPORTANT**: This hook requires a specific CLAUDE.md configuration to work properly. The template provides:
- Memory architecture definition
- Logging directives for Claude
- Format templates for memory entries
- Self-improvement guidelines

### 3. Memory Structure
```
memory/
├── daily/           # Daily interaction logs
│   └── YYYY-MM-DD.md
├── context/         # Long-term patterns and preferences
└── reflections/     # Insights and observations
```

## Installation

### Quick Setup (One Command!)
```bash
cd your-project
/path/to/memory_hook/memory-setup.sh
```

That's it! The setup script will:
✅ Install the hook to `.claude/hooks/`  
✅ Create memory directories  
✅ Add CLAUDE.md with memory config (if not exists)  
✅ Register hook in settings.json  
✅ Create today's memory file  

### Manual Installation
```bash
# 1. Create directories
mkdir -p .claude/hooks memory/daily memory/context memory/reflections

# 2. Copy the hook
cp memory-hook.sh .claude/hooks/
chmod +x .claude/hooks/memory-hook.sh

# 3. Copy CLAUDE.md template (if needed)
cp CLAUDE.md.template CLAUDE.md

# 4. Register in settings
# Add to .claude/settings.json:
{
  "hooks": {
    "UserPromptSubmit": [".claude/hooks/memory-hook.sh"]
  }
}
```

## How It Works

1. **Detection**: The hook checks for memory directories or memory-related CLAUDE.md
2. **Context Injection**: When detected, it prepends memory directives to your prompts
3. **Claude Response**: Claude sees the context and updates memory files accordingly
4. **Persistence**: Memory accumulates over time, improving assistance quality

## Example Memory Entry

```markdown
## [14:30]
**Event**: Refactored authentication module
**Type**: Task
**Context**: User prefers JWT over session-based auth
**Outcome**: Implemented JWT with refresh tokens
**Links**: auth.js, middleware/jwt.js
```

## Testing

```bash
# Test the hook manually
echo '{"hook_event_name": "UserPromptSubmit", "cwd": "'$(pwd)'"}' | .claude/hooks/memory-hook.sh

# Should output memory context if in a memory-enabled project
```

## Customization

Edit the hook to customize:
- Memory reminder text
- Detection logic for memory projects
- Context format and styling

## Privacy & Control

- 🔒 All memory is local to your project
- 📂 Review memory files anytime in `memory/`
- 🗑️ Clear memory by deleting the `memory/` directory
- ✏️ Edit memory files directly - they're just markdown

## Tips for Best Results

1. **Let Claude know about the memory system** - It will use it more effectively
2. **Review memory periodically** - Ensure it's capturing what matters
3. **Guide Claude's memory** - Tell it what's important to remember
4. **Use for long projects** - Memory shines in multi-session work

## Metadata

- **Requires**: CLAUDE.md configuration (included as template)
- **Compatibility**: Any project, but designed for long-term work
- **Dependencies**: bash, jq (for setup script)
- **Inspired by**: Experiments in AI memory and context persistence

## Troubleshooting

**Hook not activating?**
- Check for `memory/` directory in your project
- Verify hook is executable: `chmod +x .claude/hooks/memory-hook.sh`
- Ensure registered in `.claude/settings.json`

**Memory not updating?**
- Check CLAUDE.md includes memory directives
- Verify Claude has write permissions to memory directories
- Review Claude's responses for memory-related actions

**Too much context?**
- The hook only activates in projects with memory indicators
- Remove `memory/` directory to disable for a project

---

*This hook is part of the fun_hooks collection - simple, useful enhancements for Claude Code!*