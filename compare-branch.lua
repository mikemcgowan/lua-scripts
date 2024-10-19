local lib = require("lib")

local base = os.getenv("DEFAULT_BRANCH")
if arg and arg[1] then
  base = arg[1]
end

print(lib.colour_text("Ahead of " .. base, "green"))
os.execute("git lg " .. base .. "..")

print(lib.colour_text("Behind " .. base, "cyan"))
os.execute("git lg .." .. base)
