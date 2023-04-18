local api = vim.api

local function centerHorizontal(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

local function trimStartSpaces(s)
  return string.gsub(s, "[^%S\n]+", "")
end

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

return {
  centerHorizontal = centerHorizontal,
  trimStartSpaces = trimStartSpaces,
  dump = dump,
}

