local lib = require("lib")

local hello = "hello"

describe("string.add_colour", function()
  it("applies bold by default (to make the text brighter)", function()
    assert.are.same(lib.colours.bold .. hello .. lib.colours.reset, hello:add_colour())
  end)

  it("applies the given colour", function()
    assert.are.same(
      lib.colours.bold .. lib.colours.cyan .. hello .. lib.colours.reset,
      hello:add_colour(lib.colours.cyan)
    )
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

describe("string.split", function()
  it("can split a string on tabs", function()
    local s = "foo\tbar\t\twibble\twoo"
    local result = s:split("[^\t]+")
    assert.are.same({ "foo", "bar", "wibble", "woo" }, result)
  end)
end)

describe("string.to_lines", function()
  it("can split a string on new lines", function()
    local s = "line 1\r\nline 2\nline 3\r\nline 4\nline 5"
    local result = s:to_lines()
    assert.are.same({ "line 1", "line 2", "line 3", "line 4", "line 5" }, result)
  end)
end)

describe("string.pad_left", function()
  it("pads with spaces if the string is shorter than the requested size", function()
    assert.are.same((" "):rep(5) .. hello, hello:pad_left(10))
  end)

  it("returns the original string if the requested length is less than the length of the original string", function()
    assert.are.same(hello, hello:pad_left(4))
  end)
end)

describe("string.pad_right", function()
  it("pads with spaces if the string is shorter than the requested size", function()
    assert.are.same(hello .. (" "):rep(5), hello:pad_right(10))
  end)

  it("returns the original string if the requested length is less than the length of the original string", function()
    assert.are.same(hello, hello:pad_right(4))
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

describe("map", function()
  it("applies the given function to every item in the collection", function()
    assert.are.same(
      { 1, 4, 9, 16, 25, 36 },
      lib.map({ 1, 2, 3, 4, 5, 6 }, function(n)
        return n * n
      end)
    )
  end)
end)

describe("filter", function()
  it("applies the given predicate to every item in the collection", function()
    assert.are.same(
      { 4, 16, 36 },
      lib.filter({ 1, 4, 9, 16, 25, 36 }, function(n)
        return n % 2 == 0
      end)
    )
  end)
end)

describe("max_by", function()
  it("finds the largest int", function()
    local result = lib.max_by({ 5, 7, 2, 7, 9, 4 }, function(x)
      return x
    end)
    assert.are.same(9, result)
  end)

  it("finds the longest string", function()
    local result = lib.max_by({
      "short",
      "not long",
      "the very longest of all of them",
      "quite long, but not very long",
      "medium length",
      "shrt",
    }, function(x)
      return #x
    end)
    assert.are.same("the very longest of all of them", result)
  end)

  it("returns nil if there's no max", function()
    assert.are.same(
      nil,
      lib.max_by({}, function(x)
        return x
      end)
    )
  end)
end)
