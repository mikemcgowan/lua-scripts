local lib = require("lib")

local track = arg[1]
if not track then
  print(("Missing arg 1/1: exercism track"):add_colour(lib.colours.yellow))
  os.exit(1)
end

local lines = lib.load_lines_from_file("exercism/" .. track .. ".txt")
for i, exercise in ipairs(lines) do
  print(("Downloading " .. i .. " of " .. #lines):add_colour(lib.colours.green))
  os.execute("exercism download --track=" .. track .. " --exercise=" .. exercise .. " --force")
end
