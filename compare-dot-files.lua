local lfs = require("lfs")
local lib = require("lib")

local home_dir = os.getenv("HOME")
local dotfiles_dir = os.getenv("DOTFILES_DIR")
assert(dotfiles_dir ~= nil and dotfiles_dir:sub(1, 1) == "/" and dotfiles_dir:sub(#dotfiles_dir, #dotfiles_dir) == "/")
local operating_system = lib.capture_output("uname -s")
local laptop_dir = operating_system == "Darwin" and "work" or lib.capture_output("uname -n") -- the only macOS laptop is my work laptop
dotfiles_dir = home_dir .. dotfiles_dir .. laptop_dir
print(("dotfiles dir is '" .. dotfiles_dir .. "'"):add_colour())

for _, dotfile in ipairs(lib.files_in_path(dotfiles_dir)) do
  print(dotfile:add_colour())
  local root = home_dir .. "/." .. dotfile
  if lfs.attributes(root) ~= nil then
    os.execute("colordiff -u " .. dotfiles_dir .. "/" .. dotfile .. " " .. home_dir .. "/." .. dotfile)
  else
    print(("Dotfile '" .. root .. "' is missing!"):add_colour(lib.colours.yellow))
  end
end
