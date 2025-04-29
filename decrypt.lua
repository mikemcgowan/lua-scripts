local lib = require("lib")
local lfs = require("lfs")

local input = arg[2]
if not input then
  print(("Missing arg 1/1: input file to decrypt"):add_colour(lib.colours.yellow))
  os.exit(1)
end

input = arg[1] .. "/" .. input
if not lfs.attributes(input) then
  print(("Input file '" .. input .. "' is missing!"):add_colour(lib.colours.yellow))
  os.exit(1)
end

if input:sub(#input - 3, #input) ~= ".gpg" then
  print(("Can only decrypt a .gpg file"):add_colour(lib.colours.yellow))
  os.exit(1)
end

local input_without_dot_gpg = input:sub(1, #input - 4)
os.execute("gpg --decrypt " .. input .. " > " .. input_without_dot_gpg)
if lfs.attributes(input_without_dot_gpg) then
  os.execute("chmod 600 " .. input_without_dot_gpg)
end
os.execute("gpg-connect-agent reloadagent /bye")
