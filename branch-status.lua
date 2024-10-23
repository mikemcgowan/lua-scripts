local lfs = require("lfs")
local lib = require("lib")

local dir = arg[1]
if not dir then
  print(("Missing arg 1/2: directory"):add_colour(lib.colours.yellow))
  os.exit(1)
end
lfs.chdir(dir)

local base = arg[2]
if not base then
  print(("Missing arg 2/2: base branch - defaulting to 'master'"):add_colour(lib.colours.cyan))
  base = "master"
end

local refs_heads = "refs/heads/"
local for_each_ref = lib.capture_output("git for-each-ref --format='%(refname)' " .. refs_heads, "*all")
local branch_names = lib.map(for_each_ref:to_lines(), function(ref)
  return ref:sub(#refs_heads + 1, #ref)
end)

local function behind_and_ahead(from, to)
  local tabs = "[^\t]+"
  local rev_list = lib.capture_output("git rev-list --left-right --count " .. from .. "..." .. to)
  local rev_list_split = rev_list:split(tabs)
  local behind = rev_list_split[1]
  local ahead = rev_list_split[2]
  return behind, ahead
end

local branches = lib.map(branch_names, function(branch_name)
  local behind, ahead = behind_and_ahead(base, branch_name)
  local t = { name = branch_name, behind = behind, ahead = ahead }
  local remote_branch = lib.capture_output("git branch -r | grep -Po 'origin/" .. branch_name .. "' | uniq")
  if remote_branch and #remote_branch > 0 then
    behind, ahead = behind_and_ahead(branch_name, "origin/" .. branch_name)
    t.behind_remote = behind
    t.ahead_remote = ahead
  end
  return t
end)

local branch_with_longest_name = lib.max_by(branches, function(branch)
  return #branch.name
end)
local col_name_length = 1
if branch_with_longest_name then
  col_name_length = #branch_with_longest_name.name
end

for _, branch in ipairs(branches) do
  print(branch.name .. " is behind " .. branch.behind .. " and ahead " .. branch.ahead .. " of " .. base)
  if branch.ahead_remote and branch.behind_remote then
    print(
      branch.name
        .. " is behind "
        .. branch.behind_remote
        .. " and ahead "
        .. branch.ahead_remote
        .. " of origin/"
        .. branch.name
    )
  end
end
