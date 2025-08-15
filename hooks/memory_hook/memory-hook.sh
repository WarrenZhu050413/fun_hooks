#!/bin/bash

# Claude Code Memory Hook
# Injects contextual reminders about memory management and experiment tracking
# Simple and easy to understand - no complex dependencies

# Read JSON input from stdin (required by Claude Code)
json_input=$(cat)

# Extract basic fields
cwd=$(echo "$json_input" | jq -r '.cwd // ""')
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // ""')

# Only activate for user prompt submissions
if [ "$hook_event" != "UserPromptSubmit" ]; then
    exit 0
fi

# Check if we're in a project with memory directories or CLAUDE.md with memory config
has_memory=false

# Check for memory directories
if [ -d "$cwd/memory" ] || [ -d "$cwd/.memory" ]; then
    has_memory=true
fi

# Check for CLAUDE.md with memory/experiment keywords
if [ -f "$cwd/CLAUDE.md" ] && grep -q -i "memory\|experiment" "$cwd/CLAUDE.md" 2>/dev/null; then
    has_memory=true
fi

# If no memory indicators found, exit silently
if [ "$has_memory" = false ]; then
    exit 0
fi

# Get current date
today=$(date +%Y-%m-%d)

# Output contextual reminder (will be prepended to user's prompt)
cat << 'EOF'
═══════════════════════════════════════════════════════════════
🧠 MEMORY MODE ACTIVE
═══════════════════════════════════════════════════════════════

CONTEXT: This project has memory tracking enabled.
EOF

echo "TODAY: $today"
echo "MEMORY LOCATION: memory/daily/$today.md"

cat << 'EOF'

DIRECTIVES:
1. Check and update memory files as appropriate
2. Log significant interactions and decisions
3. Extract patterns for long-term memory
4. Note important context and preferences
5. Maintain awareness of conversation history

MEMORY TASKS:
- Consider if this interaction should be logged
- Update daily memory with significant events
- Check for recurring patterns
- Document insights and observations

═══════════════════════════════════════════════════════════════
EOF

exit 0