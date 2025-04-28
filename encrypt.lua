local lib = require("lib")
local lfs = require("lfs")

local input = arg[2]
if not input then
  print(("Missing arg 1/1: input file to encrypt"):add_colour(lib.colours.yellow))
  os.exit(1)
end

input = arg[1] .. "/" .. input
if not lfs.attributes(input) then
  print(("Input file '" .. input .. "' is missing!"):add_colour(lib.colours.yellow))
  os.exit(1)
end

os.execute("gpg --symmetric --cipher-algo AES256 " .. input)
os.execute("gpg-connect-agent reloadagent /bye")
