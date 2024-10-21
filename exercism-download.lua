local lib = require("lib")

local track = arg[1]
if not track then
  print(lib.colour_text("Missing arg 1/1: exercism track", "yellow"))
  os.exit(1)
end

local lines = lib.load_lines_from_file("exercism/" .. track .. ".txt")
for i, exercise in ipairs(lines) do
  print(lib.colour_text("Downloading " .. i .. " of " .. #lines, "green"))
  os.execute("exercism download --track=" .. track .. " --exercise=" .. exercise .. " --force")
end
