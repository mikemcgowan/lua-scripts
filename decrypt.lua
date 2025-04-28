local lib = require("lib")

local input = arg[1]
if not input then
  print(("Missing arg 1/1: input file to decrypt"):add_colour(lib.colours.yellow))
  os.exit(1)
end
if input:sub(#input - 3, #input) ~= ".gpg" then
  print(("Can only decrypt a .gpg file"):add_colour(lib.colours.yellow))
  os.exit(1)
end

local input_without_dot_gpg = input:sub(1, #input - 4)
os.execute("gpg --decrypt " .. input .. " > " .. input_without_dot_gpg)
os.execute("gpg-connect-agent reloadagent /bye")
