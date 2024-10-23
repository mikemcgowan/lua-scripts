local lib = require("lib")

local base = arg[1]
if not base then
  print(("Missing arg 1/1: base branch - defaulting to 'master'"):add_colour(lib.colours.cyan))
  base = "master"
end

local refs_heads = "refs/heads/"
local for_each_ref = lib.capture_output("git for-each-ref --format='%(refname)' " .. refs_heads, "*all")
local branch_names = lib.map(for_each_ref:to_lines(), function(ref)
  return ref:sub(#refs_heads + 1, #ref)
end)

local branches = lib.map(branch_names, function(branch_name)
  local rev_list = lib.capture_output("git rev-list --left-right --count " .. base .. "..." .. branch_name)
  local rev_list_split = rev_list:split("[^\t]+")
  return {
    name = branch_name,
    behind = rev_list_split[1],
    ahead = rev_list_split[2],
  }
end)

for _, branch in ipairs(branches) do
  print(branch.name .. " is behind " .. branch.behind .. " and ahead " .. branch.ahead .. " of " .. base)
end
