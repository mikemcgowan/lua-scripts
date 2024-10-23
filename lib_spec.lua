local lib = require("lib")

describe("colour_text", function()
  it("applies bold by default (to make the text brighter)", function()
    local s = "hello"
    assert.are.same(lib.colours.bold .. s .. lib.colours.reset, lib.colour_text(s))
  end)

  it("applies the given colour", function()
    local s = "hello"
    assert.are.same(
      lib.colours.bold .. lib.colours.cyan .. s .. lib.colours.reset,
      lib.colour_text(s, lib.colours.cyan)
    )
  end)
end)

describe("visible_length", function()
  it("returns the original string length if there are no colours", function()
    local s = "hello"
    assert.are.same(#s, lib.visible_length(s))
  end)

  it("returns the visible string length if there are some colours", function()
    local s = "hello"
    local coloured_s = lib.colour_text(s, lib.colours.cyan)
    assert.are.same(#s, lib.visible_length(coloured_s))
  end)
end)

describe("capture_output", function()
  it("captures the output of an echo", function()
    local s = "hello"
    assert.are.same(s, lib.capture_output("echo " .. s))
  end)

  it("captures the output of 'pwd'", function()
    local result = lib.capture_output("pwd")
    local lua_scripts = "lua-scripts"
    assert.are.same(lua_scripts, result:sub(-#lua_scripts))
  end)
end)
