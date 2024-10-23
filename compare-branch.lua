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

print(("Ahead of " .. base):add_colour(lib.colours.green))
os.execute("git lg " .. base .. "..")

print(("Behind " .. base):add_colour(lib.colours.cyan))
os.execute("git lg .." .. base)
