require("no-status"):setup()
require("starship"):setup({
	config_file = "~/.config/starship/starship_without_left_part.toml",
	show_right_prompt = true,
})
require("git"):setup({
	order = 1500,
})

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
