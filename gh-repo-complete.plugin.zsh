# gh-repo-complete - GitHub API autocomplete for gh repo clone
# Features: prefetching, caching, optimistic display

# Config
typeset -g GH_REPO_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/gh-repos-cache"
typeset -g GH_REPO_CACHE_TTL=300  # 5 minutes - when to background refresh
typeset -g GH_REPO_CACHE_STALE=3600  # 1 hour - max age before blocking refresh

# Cross-platform file mtime (macOS vs Linux)
_gh_file_mtime() {
  local file="$1"
  if [[ "$OSTYPE" == darwin* ]]; then
    stat -f %m "$file" 2>/dev/null || echo 0
  else
    stat -c %Y "$file" 2>/dev/null || echo 0
  fi
}

# Prefetch repos in background on shell start
_gh_prefetch_repos() {
  # Only prefetch if cache is stale or missing
  local cache_mtime=0
  [[ -f "$GH_REPO_CACHE_FILE" ]] && cache_mtime=$(_gh_file_mtime "$GH_REPO_CACHE_FILE")

  if [[ ! -f "$GH_REPO_CACHE_FILE" ]] || (( $(date +%s) - cache_mtime > GH_REPO_CACHE_TTL )); then
    # Background fetch - silent, non-blocking
    {
      local repos
      repos=$(gh api graphql --paginate \
        -f query='query($endCursor: String) {
          viewer {
            repositories(first: 100, after: $endCursor, affiliations: [OWNER, COLLABORATOR, ORGANIZATION_MEMBER]) {
              nodes { nameWithOwner }
              pageInfo { hasNextPage endCursor }
            }
          }
        }' -q '.data.viewer.repositories.nodes[].nameWithOwner' 2>/dev/null)

      if [[ -n "$repos" ]]; then
        echo "$repos" > "$GH_REPO_CACHE_FILE"
      fi
    } &!
  fi
}

# Get repos - optimistic: return cache immediately, refresh in background if stale
_gh_get_repos() {
  local cache_file="$GH_REPO_CACHE_FILE"
  local now=$(date +%s)
  local cache_time=0

  if [[ -f "$cache_file" ]]; then
    cache_time=$(_gh_file_mtime "$cache_file")

    # If cache exists and not completely stale, use it
    if (( now - cache_time < GH_REPO_CACHE_STALE )); then
      # Return cached data immediately (optimistic)
      cat "$cache_file"

      # Background refresh if past TTL
      if (( now - cache_time > GH_REPO_CACHE_TTL )); then
        _gh_prefetch_repos
      fi
      return
    fi
  fi

  # No cache or completely stale - blocking fetch
  local repos
  repos=$(gh api graphql --paginate \
    -f query='query($endCursor: String) {
      viewer {
        repositories(first: 100, after: $endCursor, affiliations: [OWNER, COLLABORATOR, ORGANIZATION_MEMBER]) {
          nodes { nameWithOwner }
          pageInfo { hasNextPage endCursor }
        }
      }
    }' -q '.data.viewer.repositories.nodes[].nameWithOwner' 2>/dev/null)

  if [[ -n "$repos" ]]; then
    echo "$repos" > "$cache_file"
    echo "$repos"
  fi
}

# Override _gh completion
_gh_repo_complete_init() {
  if (( $+functions[_gh] )) && (( ! $+functions[_gh_original] )); then
    # Save original
    functions[_gh_original]="${functions[_gh]}"

    # Override with our enhanced version
    _gh() {
      # Intercept 'gh repo clone <repo>'
      if [[ ${words[2]} == "repo" && ${words[3]} == "clone" && $CURRENT -eq 4 ]]; then
        local -a repos
        repos=(${(f)"$(_gh_get_repos)"})
        if (( ${#repos[@]} > 0 )); then
          _describe -t repos 'repositories' repos
          return 0
        fi
      fi
      _gh_original "$@"
    }

    # Remove hook after init
    add-zsh-hook -d precmd _gh_repo_complete_init
  fi
}

# Start prefetch immediately on plugin load (background, non-blocking)
_gh_prefetch_repos

# Hook to override _gh after oh-my-zsh fully loads
autoload -Uz add-zsh-hook
add-zsh-hook precmd _gh_repo_complete_init
