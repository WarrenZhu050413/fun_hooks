# Fun Hooks for Claude Code 🎉

A collection of delightful and useful hooks for Claude Code to enhance your development experience. These hooks add personality, feedback, and automation to your Claude Code sessions.

## About This Repository

This repository showcases various fun and practical hooks that I use with Claude Code. Each hook is designed to make development more engaging, productive, or simply more enjoyable. Feel free to use, modify, and contribute your own creative hooks!

## 🎯 Purpose

Claude Code hooks allow you to:
- **Automate workflows** - Run tests, linting, or deployments automatically
- **Add feedback** - Get notifications when Claude finishes tasks
- **Enhance productivity** - Integrate with external tools and services
- **Personalize experience** - Add your own flair to Claude interactions
- **Learn by example** - See practical hook implementations in action

## 📁 Repository Structure

```
fun_hooks/
├── README.md                    # This file - overview of all hooks
├── hooks/                      # Collection of hook implementations
│   ├── notification_hook/      # Audio notification system
│   │   ├── README.md          # Setup and usage instructions
│   │   ├── notification-setup.sh     # Installation script
│   │   └── claude-notification-hook.sh  # Hook implementation
│   └── [future_hooks]/        # More hooks coming soon!
└── test_repo/                  # Test directory for trying hooks
```

## 🔧 Available Hooks

### 🔔 Notification Hook
**Location**: `hooks/notification_hook/`

Audio notification system that announces when Claude finishes responding or needs input. Perfect for developers working in tmux or terminal environments.

**Features**:
- 🎤 Customizable text-to-speech voices (7+ options)
- ⚡ Adjustable speech rate (90-720 WPM)
- 🔊 Different sound effects for different events
- 📁 Context-aware announcements with directory names
- 🛠️ Easy global installation with `notification-setup` command

**Quick Start**:
```bash
cd hooks/notification_hook
./notification-setup.sh --voice "Samantha" --wpm 200
```

[See detailed instructions →](hooks/notification_hook/README.md)

## 🚀 Getting Started

### Prerequisites
- [Claude Code](https://claude.ai/code) installed and configured
- macOS (for notification hook - some hooks may work on other platforms)
- Basic familiarity with Claude Code hooks system

### Installation
1. Clone this repository:
   ```bash
   git clone [repository-url]
   cd fun_hooks
   ```

2. Choose a hook from the `hooks/` directory
3. Follow the specific installation instructions in each hook's README.md

### Testing
Use the `test_repo/` directory to safely test hooks before installing them in your actual projects:

```bash
cd test_repo
# Install and test a hook here first
```

## 💡 Hook Ideas & Contributions

Have a fun hook idea? I'd love to see it! Some ideas for future hooks:

- **Productivity Hooks**:
  - Pomodoro timer integration
  - Automatic git commits with AI-generated messages
  - Code complexity analysis and warnings

- **Fun Hooks**:
  - ASCII art celebrations for successful builds
  - Random motivational quotes
  - Theme music for different coding activities

- **Utility Hooks**:
  - Automatic documentation generation
  - Integration with issue trackers
  - Slack/Discord notifications for team updates

## 📖 Learning Resources

- [Claude Code Hooks Documentation](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [Claude Code Settings Reference](https://docs.anthropic.com/en/docs/claude-code/settings)
- [Hook Development Best Practices](https://docs.anthropic.com/en/docs/claude-code/hooks-guide)

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Bug fixes for existing hooks
- ✨ New hook implementations
- 📝 Documentation improvements
- 💡 Creative hook ideas

### How to Contribute
1. Fork this repository
2. Create a new hook directory under `hooks/your_hook_name/`
3. Include a comprehensive README.md with setup instructions
4. Test thoroughly in the `test_repo/` directory
5. Submit a pull request with a clear description

### Hook Submission Guidelines
- Each hook should be in its own directory under `hooks/`
- Include a detailed README.md with installation and usage instructions
- Provide example configurations and test cases
- Ensure compatibility information is clearly documented
- Follow security best practices (no hardcoded secrets, safe file operations)

## 🔒 Security Notes

- Review all hook scripts before installation
- Be cautious with hooks that modify files or execute system commands
- Test hooks in isolated environments first
- Never commit sensitive information (API keys, passwords) to hook scripts

## 📄 License

MIT License - feel free to use, modify, and distribute these hooks.

## 🙏 Acknowledgments

- The Claude Code team for creating an amazing development tool
- The open-source community for inspiration and best practices
- Contributors who share their creative hook implementations

---

**Happy coding with Claude! 🚀**

*Remember: Hooks are powerful tools that can automate and enhance your development workflow. Use them wisely and have fun!*