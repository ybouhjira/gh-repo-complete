# VHS Demo for gh-repo-complete
Output demo.gif

Set Shell "zsh"
Set FontSize 22
Set Width 800
Set Height 450
Set Theme "Catppuccin Mocha"
Set Padding 25
Set TypingSpeed 80ms

Sleep 500ms

# Show the problem
Type "# The problem: typing full repo names 😫"
Enter
Sleep 1s

Type "gh repo clone ybouhjira/what-was-it-called"
Sleep 1.5s
Ctrl+U
Sleep 500ms

# Show the solution
Type "# The solution: gh-repo-complete ⚡"
Enter
Sleep 1s

Type "gh repo clone "
Sleep 500ms

# Simulate pressing Tab
Type "[TAB]"
Sleep 1s
Backspace 5

Enter
Sleep 300ms

# Show fake autocomplete menu
Type "  ybouhjira/dotfiles"
Enter
Type "  ybouhjira/gh-repo-complete"
Enter
Type "  ybouhjira/my-awesome-project"
Enter
Type "  ybouhjira/terminal-tools"
Sleep 2s

Ctrl+U
Type "clear"
Enter
Sleep 300ms

# Final message
Type "# Prefetched on shell start = instant! 🚀"
Enter
Sleep 2s
