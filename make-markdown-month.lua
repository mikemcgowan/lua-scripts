local lib = require("lib")

local DAYS_IN_MONTH = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

local function get_days_in_month(year, month)
  if month == 2 and year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0) then
    return 29
  else
    return DAYS_IN_MONTH[month]
  end
end

local function get_first_day_of_week(year, month)
  local first_day_timestamp = os.time({ year = year, month = month, day = 1, hour = 0, min = 0, sec = 0 })
  return os.date("*t", first_day_timestamp).wday -- 1=Sunday, 2=Monday, ..., 7=Saturday
end

local function day_of_week_text(day_of_week)
  if day_of_week == 7 then
    return "Sat"
  elseif day_of_week == 1 then
    return "Sun"
  end
  return "✓✗"
end

if not arg[1] then
  print(("Missing arg 1/2: year"):add_colour(lib.colours.yellow))
end

if not arg[2] then
  print(("Missing arg 2/2: month"):add_colour(lib.colours.yellow))
end

arg[1] = tonumber(arg[1])
arg[2] = tonumber(arg[2])

if not arg[1] or not arg[2] then
  os.exit(1)
end

print("| Day | Alcohol | Coffee |")
print("|----:|--------:|-------:|")

local days_in_month = get_days_in_month(arg[1], arg[2])
local day_of_week = get_first_day_of_week(arg[1], arg[2])
for day_in_month = 1, days_in_month do
  print("| " .. day_in_month .. " | " .. day_of_week_text(day_of_week) .. " | ✓✗ |")
  day_of_week = day_of_week + 1
  if day_of_week > 7 then
    day_of_week = 1
  end
end
