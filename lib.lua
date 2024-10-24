local lfs = require("lfs")

local colours = {
  reset = "\27[0m",
  bold = "\27[1m",
  green = "\27[32m",
  yellow = "\27[33m",
  cyan = "\27[36m",
}

local table_chars = {
  horiz = "─",
  verti = "│",
  top_l = "┌",
  bot_r = "┘",
  top_r = "┐",
  bot_l = "└",
  top_t = "┬",
  bot_t = "┴",
  jun_l = "├",
  jun_r = "┤",
  cross = "┼",
}

function string.add_colour(text, colour)
  local s = colours.bold
  if colour then
    s = s .. colour
  end
  s = s .. text .. colours.reset
  return s
end

function string.visible_length(text)
  local ansi_pattern = "\27%[%d+m"
  local stripped = text:gsub(ansi_pattern, "")
  return #stripped
end

function string.split(text, expr)
  local lines = {}
  for line in text:gmatch(expr) do
    table.insert(lines, line)
  end
  return lines
end

function string.to_lines(text)
  return text:split("[^\r\n]+")
end

function string.pad_left(text, size)
  if text:visible_length() >= size then
    return text
  else
    return (" "):rep(size - text:visible_length()) .. text
  end
end

function string.pad_right(text, size)
  if text:visible_length() >= size then
    return text
  else
    return text .. (" "):rep(size - text:visible_length())
  end
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
    print(("Could not open file '" .. filename .. "'"):add_colour(colours.yellow))
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

local function map(t, f)
  local u = {}
  for _, v in ipairs(t) do
    table.insert(u, f(v))
  end
  return u
end

local function filter(t, p)
  local u = {}
  for _, v in ipairs(t) do
    if p(v) then
      table.insert(u, v)
    end
  end
  return u
end

local function max_by(t, f)
  local max = nil
  local max_value = nil
  for _, v in ipairs(t) do
    if not max_value or f(v) > max_value then
      max_value = f(v)
      max = v
    end
  end
  return max
end

return {
  colours = colours,
  table_chars = table_chars,
  capture_output = capture_output,
  load_lines_from_file = load_lines_from_file,
  files_in_path = files_in_path,
  map = map,
  filter = filter,
  max_by = max_by,
}
