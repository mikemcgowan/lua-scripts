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

local base_exists = lib.capture_output("git branch -a --format='%(refname:short)' | grep -P '^" .. base .. "$'")
if not base_exists or #base_exists == 0 or base_exists ~= base then
  print(("Can't find base branch '" .. base .. "'"):add_colour(lib.colours.yellow))
  os.exit(1)
end
print(("Branch status relative to base branch '" .. base .. "'"):add_colour(lib.colours.cyan))

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
  local remote_branch =
    lib.capture_output("git branch -r --format='%(refname:short)' | grep -Po 'origin/" .. branch_name .. "' | uniq")
  if remote_branch and #remote_branch > 0 then
    behind, ahead = behind_and_ahead("origin/" .. branch_name, branch_name)
    t.behind_remote = behind
    t.ahead_remote = ahead
  end
  return t
end)

local col_widths = {
  first = #" Branch ",
  behind = #" Behind ",
  ahead = #" Ahead ",
  behind_ahead = #" Behind | Ahead ",
}

local branch_with_longest_name = lib.max_by(branches, function(branch)
  return #branch.name
end)

if branch_with_longest_name and #branch_with_longest_name.name > col_widths.first then
  col_widths.first = #branch_with_longest_name.name
end

local box = lib.table_chars

local function top_border_row()
  return box.top_l
    .. box.horiz:rep(col_widths.first + 2)
    .. box.top_t
    .. box.horiz:rep(col_widths.behind_ahead)
    .. box.top_t
    .. box.horiz:rep(col_widths.behind_ahead)
    .. box.top_r
end

local function header_row()
  return box.verti
    .. " Branch "
    .. (" "):rep(col_widths.first - #" Branch " + 2)
    .. box.verti
    .. (" vs " .. base:sub(1, col_widths.behind_ahead - 5) .. " "):pad_right(col_widths.behind_ahead):add_colour()
    .. box.verti
    .. (" vs origin "):pad_right(col_widths.behind_ahead)
    .. box.verti
end

local function horiz_div_row(bits, horiz1, horiz2)
  assert(#bits == 6)
  return bits[1]
    .. (horiz1 and box.horiz:rep(col_widths.first + 2) or (" "):rep(col_widths.first + 2))
    .. bits[2]
    .. (horiz2 and box.horiz:rep(col_widths.behind) or " Behind ")
    .. bits[3]
    .. (horiz2 and box.horiz:rep(col_widths.ahead) or " Ahead ")
    .. bits[4]
    .. (horiz2 and box.horiz:rep(col_widths.behind) or " Behind ")
    .. bits[5]
    .. (horiz2 and box.horiz:rep(col_widths.ahead) or " Ahead ")
    .. bits[6]
end

local function behind_colour(n)
  if not n then
    return lib.colours.bold
  elseif n == 0 then
    return lib.colours.cyan
  else
    return lib.colours.yellow
  end
end

local function ahead_colour(n)
  if not n then
    return lib.colours.bold
  elseif n == 0 then
    return lib.colours.cyan
  else
    return lib.colours.green
  end
end

local function branch_row(branch, behind_remote, ahead_remote)
  return box.verti
    .. " "
    .. branch.name:pad_right(col_widths.first + 1):add_colour()
    .. box.verti
    .. tostring(branch.behind):pad_left(col_widths.behind - 1):add_colour(behind_colour(branch.behind))
    .. " "
    .. box.verti
    .. tostring(branch.ahead):pad_left(col_widths.ahead - 1):add_colour(ahead_colour(branch.ahead))
    .. " "
    .. box.verti
    .. behind_remote:pad_left(col_widths.behind - 1):add_colour(behind_colour(branch.behind_remote))
    .. " "
    .. box.verti
    .. ahead_remote:pad_left(col_widths.ahead - 1):add_colour(ahead_colour(branch.ahead_remote))
    .. " "
    .. box.verti
end

local function print_table()
  print(top_border_row())
  print(header_row())
  print(horiz_div_row({ box.verti, box.jun_l, box.top_t, box.cross, box.top_t, box.jun_r }, false, true))
  print(horiz_div_row({ box.verti, box.verti, box.verti, box.verti, box.verti, box.verti }, false, false))
  print(horiz_div_row({ box.jun_l, box.cross, box.cross, box.cross, box.cross, box.jun_r }, true, true))
  for _, branch in ipairs(branches) do
    local behind_remote = branch.behind_remote and tostring(branch.behind_remote) or "n/a"
    local ahead_remote = branch.ahead_remote and tostring(branch.ahead_remote) or "n/a"
    print(branch_row(branch, behind_remote, ahead_remote))
  end
  print(horiz_div_row({ box.bot_l, box.bot_t, box.bot_t, box.bot_t, box.bot_t, box.bot_r }, true, true))
end

print_table()
