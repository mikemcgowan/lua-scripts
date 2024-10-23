local lib = require("lib")

local hello = "hello"

describe("string.add_colour", function()
  it("applies bold by default (to make the text brighter)", function()
    assert.are.same(lib.colours.bold .. hello .. lib.colours.reset, hello:add_colour())
  end)

  it("applies the given colour", function()
    assert.are.same(lib.colours.bold .. lib.colours.cyan .. hello .. lib.colours.reset, hello:add_colour(lib.colours.cyan))
  end)
end)

describe("string.visible_length", function()
  it("returns the original string length if there are no colours", function()
    assert.are.same(#hello, hello:visible_length())
  end)

  it("returns the visible string length if there are some colours", function()
    local coloured_s = hello:add_colour(lib.colours.cyan)
    assert.are.same(#hello, coloured_s:visible_length())
  end)
end)

describe("capture_output", function()
  it("captures the output of an echo", function()
    assert.are.same(hello, lib.capture_output("echo " .. hello))
  end)

  it("captures the output of 'pwd'", function()
    local result = lib.capture_output("pwd")
    local lua_scripts = "lua-scripts"
    assert.are.same(lua_scripts, result:sub(-#lua_scripts))
  end)
end)

describe("load_lines_from_file", function()
  it("loads lines from a plain text file", function()
    local expected_line_count = 5
    local result = lib.load_lines_from_file("spec/fixtures/load_lines_from_file.txt")
    assert.are.same(expected_line_count, #result)
    for i = 1, expected_line_count do
      assert.are.same("line " .. i, result[i])
    end
  end)
end)

describe("files_in_path", function()
  it("gets files in given path", function()
    local expected_file_count = 3
    local result = lib.files_in_path("spec/fixtures/files_in_path/")
    assert.are.same(expected_file_count, #result)
    table.sort(result)
    for i = 1, expected_file_count do
      assert.are.same("file" .. i .. ".txt", result[i])
    end
  end)
end)
