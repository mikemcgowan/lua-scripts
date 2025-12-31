local config_files = {
  ".local/share/applications/kitty.desktop",
  ".config/kitty/kitty.conf",
  ".config/starship.toml",
}

for _, config_file in ipairs(config_files) do
  os.execute("git diff ~/" .. config_file .. " " .. "~/pCloudDrive/Config/")
end
