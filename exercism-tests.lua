local lfs = require("lfs")
local lib = require("lib")

local track = arg[1]
if not track then
  print(("Missing arg 1/1: exercism track"):add_colour(lib.colours.yellow))
  os.exit(1)
end

local successful = 0
local failures = {}
local lines = lib.load_lines_from_file("exercism/" .. track .. ".txt")
local home_dir = os.getenv("HOME")
local exercism_dir = os.getenv("EXERCISM_DIR")
assert(exercism_dir ~= nil and exercism_dir:sub(1, 1) == "/" and exercism_dir:sub(#exercism_dir, #exercism_dir) == "/")
lfs.chdir(home_dir .. exercism_dir .. track)

for _, exercise in ipairs(lines) do
  local attr = lfs.attributes(exercise)
  if attr and attr.mode == "directory" then
    lfs.chdir(exercise)
    local status, _, _ = os.execute("exercism test")
    if status then
      successful = successful + 1
    else
      table.insert(failures, exercise)
    end
    lfs.chdir("..")
  else
    print(("Skipping '" .. exercise .. "' as it doesn't appear to be downloaded"):add_colour(lib.colours.yellow))
  end
end

print((successful .. " out of " .. #lines .. " succeeded"):add_colour(lib.colours.green))
if #failures > 0 then
  local s = #failures == 1 and "exercise" or "exercises"
  print(("The following " .. #failures .. " " .. s .. " failed:"):add_colour(lib.colours.yellow))
  for _, v in ipairs(failures) do
    print(v:add_colour())
  end
end
