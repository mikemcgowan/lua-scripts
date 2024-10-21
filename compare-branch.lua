local lfs = require("lfs")
local lib = require("lib")

local dir = arg[1]
if not dir then
  print(lib.colour_text("Missing arg 1/2: directory", lib.colours.yellow))
  os.exit(1)
end
lfs.chdir(dir)

local base = arg[2]
if not base then
  print(lib.colour_text("Missing arg 2/2: base branch - defaulting to 'master'", lib.colours.cyan))
  base = "master"
end

print(lib.colour_text("Ahead of " .. base, lib.colours.green))
os.execute("git lg " .. base .. "..")

print(lib.colour_text("Behind " .. base, lib.colours.cyan))
os.execute("git lg .." .. base)
