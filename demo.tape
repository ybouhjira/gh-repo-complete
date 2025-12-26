# VHS Demo - gh-repo-complete usage
Output demo.gif

Set Shell "zsh"
Set FontSize 24
Set Width 700
Set Height 300
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 100ms

Sleep 500ms

Type "gh repo clone "
Sleep 600ms

# Show TAB press
Type "⇥"
Sleep 800ms
Backspace 1

# Show autocomplete results
Enter
Type "  ybouhjira/dotfiles"
Enter
Type "  ybouhjira/gh-repo-complete"
Enter
Type "  ybouhjira/my-project"
Enter
Type "  ybouhjira/awesome-cli"
Sleep 1.5s

# Select one
Hide
Ctrl+C
Type "clear"
Enter
Show
Sleep 200ms

Type "gh repo clone ybouhjira/gh-repo-complete"
Sleep 800ms
Enter
Sleep 1.5s
