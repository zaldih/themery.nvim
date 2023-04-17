local api = vim.api

local function centerHorizontal(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

local function trimStartSpaces(s)
  return string.gsub(s, "[^%S\n]+", "")
end

return {
  centerHorizontal = centerHorizontal,
  trimStartSpaces = trimStartSpaces,
}

