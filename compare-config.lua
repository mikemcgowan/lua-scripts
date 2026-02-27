local config_files = {
  ".local/share/applications/kitty.desktop",
  ".config/kitty/kitty.conf",
  ".config/starship.toml",
}

local home_dir = os.getenv("HOME")
local config_dir = os.getenv("CONFIG_DIR")
assert(config_dir ~= nil and config_dir:sub(1, 1) == "/" and config_dir:sub(#config_dir, #config_dir) == "/")
config_dir = home_dir .. config_dir

for _, config_file in ipairs(config_files) do
  print(config_file)
  os.execute("colordiff -u ~/" .. config_file .. " " .. config_dir)
end
