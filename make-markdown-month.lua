local lib = require("lib")

local function month_info(year, month)
  local first_day_timestamp = os.time({ year = year, month = month, day = 1, hour = 0, min = 0, sec = 0 })
  local first_day_of_week = os.date("*t", first_day_timestamp).wday -- 1=Sunday, 2=Monday, ..., 7=Saturday
  month = month + 1
  if month > 12 then
    month = 1
    year = year + 1
  end
  local last_day_timestamp = os.time({ year = year, month = month, day = 1, hour = 0, min = 0, sec = 0 }) - 1
  local last_day = os.date("*t", last_day_timestamp).day
  return {
    days_in_month = last_day,
    first_day_of_week = first_day_of_week,
  }
end

local function day_of_week_text(day_of_week)
  if day_of_week == 7 then
    return "Sat"
  elseif day_of_week == 1 then
    return "Sun"
  end
  return "   "
end

if not arg[1] then
  print(lib.colour_text("Missing arg 1/2: year", lib.colours.yellow))
end

if not arg[2] then
  print(lib.colour_text("Missing arg 2/2: month", lib.colours.yellow))
end

if not arg[1] or not arg[2] then
  os.exit(1)
end

print(lib.colour_text("| Day | Alcohol | Coffee |"))
print(lib.colour_text("| --- | ------- | ------ |"))

local info = month_info(arg[1], arg[2])
local day_of_week = info.first_day_of_week
for day_in_month = 1, info.days_in_month do
  print(
    lib.colour_text(
      "|  " .. string.format("%2d", day_in_month) .. " | " .. day_of_week_text(day_of_week) .. "     |        |"
    )
  )
  day_of_week = day_of_week + 1
  if day_of_week > 7 then
    day_of_week = 1
  end
end
