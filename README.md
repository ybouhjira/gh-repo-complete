<p align="center">
  <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" width="80" alt="GitHub Logo"/>
</p>

<h1 align="center">gh-repo-complete</h1>

<p align="center">
  <strong>Blazing fast GitHub repository autocomplete for <code>gh repo clone</code></strong>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#how-it-works">How It Works</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/oh--my--zsh-plugin-blue?style=flat-square&logo=gnu-bash" alt="oh-my-zsh plugin"/>
  <img src="https://img.shields.io/badge/shell-zsh-green?style=flat-square&logo=zsh" alt="zsh"/>
  <img src="https://img.shields.io/badge/GitHub%20CLI-required-black?style=flat-square&logo=github" alt="GitHub CLI"/>
  <img src="https://img.shields.io/github/license/ybouhjira/gh-repo-complete?style=flat-square" alt="License"/>
</p>

---

## The Problem

Ever typed `gh repo clone` and wished it would autocomplete your repository names? The default GitHub CLI doesn't fetch your repos for tab completion—you have to remember and type the full name.

## The Solution

**gh-repo-complete** enhances your `gh` CLI with smart, fast autocomplete:

```bash
$ gh repo clone <TAB>
ybouhjira/dotfiles          ybouhjira/my-app
ybouhjira/awesome-project   ybouhjira/cli-tool
```

## Features

| Feature | Description |
|---------|-------------|
| 🚀 **Prefetching** | Fetches repos in background when shell starts |
| ⚡ **Instant Results** | Shows cached repos immediately on `<TAB>` |
| 💾 **Smart Caching** | 5-min soft TTL with background refresh |
| 🔄 **Optimistic Updates** | Display cache first, refresh async |
| 🔌 **Non-Invasive** | Only enhances `gh repo clone`, nothing else |

## Installation

### Prerequisites

- [oh-my-zsh](https://ohmyz.sh/)
- [GitHub CLI](https://cli.github.com/) (`gh`) authenticated

### Quick Install

```bash
# Clone to oh-my-zsh custom plugins
git clone https://github.com/ybouhjira/gh-repo-complete.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/gh-repo-complete
```

### Enable the Plugin

Add `gh-repo-complete` to your plugins in `~/.zshrc` (after `gh`):

```zsh
plugins=(
  git
  gh                  # Built-in gh plugin (required)
  gh-repo-complete    # This plugin
  # ... other plugins
)
```

Reload your shell:

```bash
source ~/.zshrc
```

## Usage

Just use `gh repo clone` as normal and press `<TAB>`:

```bash
# Autocomplete your repos
gh repo clone <TAB>

# Filter by typing
gh repo clone my-<TAB>

# Works with any user/org you have access to
gh repo clone myorg/<TAB>
```

## Configuration

Optional settings (add to `~/.zshrc` before oh-my-zsh is sourced):

```zsh
# Soft TTL - triggers background refresh (default: 5 minutes)
GH_REPO_CACHE_TTL=300

# Hard TTL - forces blocking refresh (default: 1 hour)
GH_REPO_CACHE_STALE=3600
```

### Cache Location

```bash
~/.cache/gh-repos-cache
```

Clear cache manually:

```bash
rm ~/.cache/gh-repos-cache
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Shell Starts                                              │
│        │                                                    │
│        ▼                                                    │
│   ┌─────────────────┐                                       │
│   │   Prefetch      │───▶ Background API call (non-blocking)│
│   │   (async)       │     Fetches all accessible repos      │
│   └─────────────────┘                                       │
│                                                             │
│   User types: gh repo clone <TAB>                           │
│        │                                                    │
│        ▼                                                    │
│   ┌─────────────────┐     ┌────────────────────┐           │
│   │   Read Cache    │────▶│  Instant Results!  │           │
│   └─────────────────┘     └────────────────────┘           │
│        │                                                    │
│        ▼ (if cache > 5 min old)                            │
│   Background refresh for next completion                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### API Query

Uses GitHub's GraphQL API to fetch repos you have access to:

```graphql
query {
  viewer {
    repositories(
      first: 100
      affiliations: [OWNER, COLLABORATOR, ORGANIZATION_MEMBER]
    ) {
      nodes { nameWithOwner }
    }
  }
}
```

## Troubleshooting

### Completions not showing?

1. Make sure `gh` is authenticated: `gh auth status`
2. Clear cache and reload: `rm ~/.cache/gh-repos-cache && source ~/.zshrc`
3. Wait 2-3 seconds for prefetch, then try `<TAB>`

### Slow first completion?

The first `<TAB>` after clearing cache may take 1-2 seconds. After that, it's instant from cache.

## Contributing

Contributions welcome! Feel free to open issues or PRs.

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ for the terminal
</p>
