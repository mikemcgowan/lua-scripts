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
  local behind = tonumber(rev_list_split[1])
  local ahead = tonumber(rev_list_split[2])
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

-- table header
local box = lib.table_chars
print(
  box.top_l
    .. box.horiz:rep(col_name_length + 2)
    .. box.top_t
    .. box.horiz:rep(#" Behind | Ahead ")
    .. box.top_t
    .. box.horiz:rep(#" Behind | Ahead ")
    .. box.top_r
)
print(
  box.verti
    .. " Branch "
    .. (" "):rep(col_name_length - #" Branch " + 2)
    .. box.verti
    .. (" vs " .. base:sub(1, #"Behind | Ahead" - 3) .. " "):pad_right(#" Behind | Ahead "):add_colour()
    .. box.verti
    .. (" vs origin "):pad_right(#" Behind | Ahead ")
    .. box.verti
)
print(
  box.verti
    .. (" "):rep(col_name_length + 2)
    .. box.jun_l
    .. box.horiz:rep(#" Behind ")
    .. box.top_t
    .. box.horiz:rep(#" Ahead ")
    .. box.cross
    .. box.horiz:rep(#" Behind ")
    .. box.top_t
    .. box.horiz:rep(#" Ahead ")
    .. box.jun_r
)
print(
  box.verti
    .. (" "):rep(col_name_length + 2)
    .. box.verti
    .. " Behind "
    .. box.verti
    .. " Ahead "
    .. box.verti
    .. " Behind "
    .. box.verti
    .. " Ahead "
    .. box.verti
)
print(
  box.jun_l
    .. box.horiz:rep(col_name_length + 2)
    .. box.cross
    .. box.horiz:rep(#" Behind ")
    .. box.cross
    .. box.horiz:rep(#" Ahead ")
    .. box.cross
    .. box.horiz:rep(#" Behind ")
    .. box.cross
    .. box.horiz:rep(#" Ahead ")
    .. box.jun_r
)

local function behind_colour(n)
  if not n then
    return lib.colours.bold
  else
    return n == 0 and lib.colours.cyan or lib.colours.yellow
  end
end

local function ahead_colour(n)
  if not n then
    return lib.colours.bold
  else
    return n == 0 and lib.colours.cyan or lib.colours.green
  end
end

-- loop over branches
for _, branch in ipairs(branches) do
  local behind_remote = branch.behind_remote and tostring(branch.behind_remote) or "n/a"
  local ahead_remote = branch.ahead_remote and tostring(branch.ahead_remote) or "n/a"
  print(
    box.verti
      .. " "
      .. branch.name:pad_right(col_name_length + 1):add_colour()
      .. box.verti
      .. tostring(branch.behind):pad_left(#" Behind"):add_colour(behind_colour(branch.behind))
      .. " "
      .. box.verti
      .. tostring(branch.ahead):pad_left(#" Ahead"):add_colour(ahead_colour(branch.ahead))
      .. " "
      .. box.verti
      .. behind_remote:pad_left(#" Behind"):add_colour(behind_colour(branch.behind_remote))
      .. " "
      .. box.verti
      .. ahead_remote:pad_left(#" Ahead"):add_colour(ahead_colour(branch.ahead_remote))
      .. " "
      .. box.verti
  )
end

-- table footer
print(
  box.bot_l
    .. box.horiz:rep(col_name_length + 2)
    .. box.bot_t
    .. box.horiz:rep(#" Behind ")
    .. box.bot_t
    .. box.horiz:rep(#" Ahead ")
    .. box.bot_t
    .. box.horiz:rep(#" Behind ")
    .. box.bot_t
    .. box.horiz:rep(#" Ahead ")
    .. box.bot_r
)
