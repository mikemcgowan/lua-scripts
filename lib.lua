local lfs = require("lfs")

local colours = {
  reset = "\27[0m",
  bold = "\27[1m",
  green = "\27[32m",
  yellow = "\27[33m",
  cyan = "\27[36m",
}

local function colour_text(text, colour)
  local s = colours.bold
  if colour then
    s = s .. colour
  end
  s = s .. text .. colours.reset
  return s
end

local function capture_output(cmd, mode)
  mode = mode or "*line"
  local f = assert(io.popen(cmd, "r"))
  local output = f:read(mode)
  f:close()
  return output
end

local function load_lines_from_file(filename)
  local file = io.open(filename, "r")
  if not file then
    print(colour_text("Could not open file '" .. filename .. "'", colours.yellow))
    os.exit(1)
  end
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function files_in_path(path)
  local files = {}
  for file in lfs.dir(path) do
    local attrs = lfs.attributes(path .. "/" .. file)
    if attrs.mode == "file" then
      table.insert(files, file)
    end
  end
  return files
end

return {
  colours = colours,
  colour_text = colour_text,
  capture_output = capture_output,
  load_lines_from_file = load_lines_from_file,
  files_in_path = files_in_path,
}
