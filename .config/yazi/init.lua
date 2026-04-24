require("full-border"):setup {
	type = ui.Border.PLAIN,
}
require("no-status"):setup()

function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%d/%m/%y", time) == os.date("%d/%m/%y") then
    time = os.date("%H:%M", time)
  else
    time = os.date("%d/%m/%y", time)
  end

  local size = self._file:size()
  return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
