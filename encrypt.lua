local lib = require("lib")

local input = arg[1]
if not input then
  print(("Missing arg 1/1: input file to encrypt"):add_colour(lib.colours.yellow))
  os.exit(1)
end

os.execute("gpg --symmetric --cipher-algo AES256 " .. input)
os.execute("gpg-connect-agent reloadagent /bye")
