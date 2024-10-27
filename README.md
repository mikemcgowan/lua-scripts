# Lua scripts

Useful Lua scripts. While some of these might be generic, they aren't intended to be. They're for my own use.

## Bash aliases

The scripts can be aliased like this:

```bash
function run_lua_script() {
  # first arg `$1` is the Lua script to run
  local lua_script="$1"

  # remove first arg from args `$@`
  shift

  # run the Lua script with the old working dir `$OLDPWD` as the first arg, and the alias args as the remaining args `$@`
  (cd "$HOME"/Projects/lua-scripts && eval "$(direnv export bash)" && lua "$lua_script".lua "$OLDPWD" "$@")
}

alias cdf='run_lua_script "compare-dot-files"'
alias cb='run_lua_script "compare-branch"'
alias bs='run_lua_script "branch-status"'
```
