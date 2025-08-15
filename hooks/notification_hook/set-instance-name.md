# Set Claude Instance Name

<task>
You are an identity analyzer that determines an appropriate short instance name for Claude based on conversation history and context. Generate memorable, descriptive names that capture the current role or focus area.
</task>

<context>
This command analyzes recent conversation patterns and memory to save a contextually appropriate instance name to `.claude/instance_name.txt`. This name can be read by notification systems (like notification_hook) to identify which "version" of Claude is active.

The name should be:
- **Short**: 1-3 words maximum
- **Clear**: Immediately understandable
- **Contextual**: Reflects current conversation focus
- **Memorable**: Easy to recognize in notifications
</context>

<process>
1. **Analyze Current Context**:
   - Read recent conversation history
   - Check current working directory and project type
   - Review recent tool usage patterns
   - Note dominant themes or activities

2. **Check Memory Files** (if available):
   - Look for `memory/daily/$(date +%Y-%m-%d).md`
   - Review recent interaction types
   - Identify current experiment phase or project focus

3. **Determine Instance Type**:
   Based on analysis, select the most appropriate name pattern:
   
   **Technical Roles**:
   - `Code-Assistant` - General programming help
   - `Debug-Helper` - Troubleshooting/debugging focus
   - `Architect` - System design and planning
   - `DevOps` - Infrastructure and deployment
   - `API-Builder` - API development focus
   
   **Creative/Planning Roles**:
   - `Idea-Explorer` - Brainstorming and ideation
   - `Doc-Writer` - Documentation focus
   - `Planner` - Project planning and organization
   - `Reviewer` - Code/content review mode
   
   **Specialized Roles**:
   - `Memory-Keeper` - Memory management and curation
   - `Philosophy-Guide` - Philosophical discussions
   - `Research-Assistant` - Information gathering
   - `Experiment-Observer` - Tracking experimental work
   - `Voice-Explorer` - Audio/voice technology focus
   - `Hackathon-Buddy` - Competition preparation
   
   **Hybrid Roles**:
   - `Code-Philosopher` - Technical + philosophical
   - `Build-Explorer` - Implementation + experimentation
   - `Tech-Curator` - Technical + organization

4. **Save the Instance Name**:
   ```bash
   mkdir -p .claude
   echo "[chosen-name]" > .claude/instance_name.txt
   ```
   
   Note: The name is saved to a file that hooks and scripts can read directly.

5. **Provide Confirmation**:
   - Display the chosen name
   - Explain why this name was selected
   - Show how to use it in scripts/hooks
</process>

<decision_factors>
Consider these factors when choosing a name:

1. **Recent Activity** (Last 10 messages):
   - Coding → Technical role
   - Planning → Creative role  
   - Debugging → Helper role
   - Philosophy → Guide role

2. **Tool Usage Patterns**:
   - Heavy file editing → `Code-Assistant`
   - Lots of reading/analysis → `Reviewer`
   - Memory operations → `Memory-Keeper`
   - Web searches → `Research-Assistant`

3. **Project Context**:
   - In experiment directory → `Experiment-Observer`
   - In hooks directory → `Hook-Builder`
   - In voice/AI project → Related specialist name

4. **Conversation Tone**:
   - Technical/precise → Professional role
   - Exploratory/curious → Explorer/Guide role
   - Supportive/helpful → Assistant/Helper role
</decision_factors>

<output_format>
```
🏷️ Setting Instance Name: [CHOSEN-NAME]

**Rationale**: Based on [brief explanation of why this name was chosen]

**Recent Context**:
- Primary activity: [main focus area]
- Conversation style: [technical/creative/philosophical]
- Current project: [if identifiable]

**Usage**:
- Saved to: .claude/instance_name.txt
- Integration: Ready for use with notification_hook and other tools
- Hooks can read: `cat .claude/instance_name.txt`

This name will help identify this Claude instance in notifications and logs.
```
</output_format>

<integration_notes>
**For use with notification_hook**:
The notification_hook can read the instance name from the file:
```bash
# In notification_hook:
if [ -f ".claude/instance_name.txt" ]; then
    INSTANCE_NAME=$(cat .claude/instance_name.txt)
else
    INSTANCE_NAME="Claude"
fi
osascript -e "display notification \"$INSTANCE_NAME: $message\" ..."
```

**Persistence**:
- The instance name is automatically saved to `.claude/instance_name.txt`
- Hooks and scripts can read this file directly
- No environment variable setup required
</integration_notes>

<examples>
**Example 1**: Heavy coding session with debugging
- Analysis: Multiple file edits, error fixes, test runs
- Name: `Debug-Helper`

**Example 2**: Philosophical discussion about AI boundaries
- Analysis: Abstract concepts, Heidegger references, experiment reflection
- Name: `Philosophy-Guide`

**Example 3**: Setting up voice cloning and exploring hackathons
- Analysis: New technology exploration, research focus
- Name: `Tech-Explorer`

**Example 4**: Managing memory files and creating commands
- Analysis: Memory operations, command creation, organization
- Name: `Memory-Keeper`
</examples>

IMPORTANT: Keep names short and immediately recognizable. The goal is quick identification, not complete description.