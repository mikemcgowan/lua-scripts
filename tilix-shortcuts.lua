for i = 0, 9 do
  os.execute("dconf write /com/gexperts/Tilix/keybindings/session-switch-to-terminal-" .. i .. " \"'disabled'\"")
  os.execute("dconf write /com/gexperts/Tilix/keybindings/win-switch-to-session-" .. i .. " \"'Alt<" .. i .. ">'\"")
  os.execute("dconf read /com/gexperts/Tilix/keybindings/session-switch-to-terminal-" .. i)
  os.execute("dconf read /com/gexperts/Tilix/keybindings/win-switch-to-session-" .. i)
end
