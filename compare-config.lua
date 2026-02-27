local config_files = {
  { dir = "/.local/share/applications/", file = "kitty.desktop" },
  { dir = "/.config/kitty/", file = "kitty.conf" },
  { dir = "/.config/", file = "starship.toml" },
}

local home_dir = os.getenv("HOME")
local config_dir = os.getenv("CONFIG_DIR")
assert(config_dir ~= nil and config_dir:sub(1, 1) == "/" and config_dir:sub(#config_dir, #config_dir) == "/")
config_dir = home_dir .. config_dir

for _, config_file in ipairs(config_files) do
  local dir = config_file.dir
  local file = config_file.file
  print(file)
  os.execute("colordiff -u " .. config_dir .. file .. " " .. home_dir .. dir .. file)
end
