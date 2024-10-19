local lfs = require("lfs")
local lib = require("lib")

local home_dir = os.getenv("HOME")
local dotfiles_dir = os.getenv("DOTFILES_DIR")
assert(dotfiles_dir ~= nil and dotfiles_dir:sub(1, 1) == "/" and dotfiles_dir:sub(#dotfiles_dir, #dotfiles_dir) == "/")
local host_name = lib.capture_output("uname -n")
dotfiles_dir = home_dir .. dotfiles_dir .. host_name
print(lib.colour_text("Host name is '" .. host_name .. "' so dotfiles dir is '" .. dotfiles_dir .. "'"))

for _, dotfile in ipairs(lib.files_in_path(dotfiles_dir)) do
  print(lib.colour_text(dotfile))
  local root = home_dir .. "/." .. dotfile
  if lfs.attributes(root) ~= nil then
    os.execute("git diff ~/." .. dotfile .. " " .. dotfiles_dir .. "/" .. dotfile)
  else
    print(lib.colour_text("Dotfile '" .. root .. "' is missing!", "yellow"))
  end
end
