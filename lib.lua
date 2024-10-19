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
    s = s .. colours[colour]
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
  colour_text = colour_text,
  capture_output = capture_output,
  files_in_path = files_in_path,
}
