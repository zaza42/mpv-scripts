--
-- download youtue auto-generated english subtitles
--   ( copy me to ~/.config/mpv/scripts/ )
--
-- required binaries:
-- youtube-dl   - https://youtube-dl.org/
--
local key_binding = "ctrl+v"
local utils = require 'mp.utils'
local msg = require 'mp.msg'
local autosub = "/dev/shm/mpv-autosub"

function getautosub()
	filepath = mp.get_property("path")
	if (filepath:find("http") ~= 1) then return end
	msg.warn("download autosub")
        mp.osd_message("downloading auto-generated subtitles", osd_time)

        cmd = { args = { 'sh', '-c',
	    "youtube-dl --skip-download --write-auto-sub -o " .. autosub .. " '" .. filepath .. "'"} }
        utils.subprocess(cmd)
	mp.command("sub_add " .. autosub .. ".en.vtt")
	os.remove(autosub .. ".en.vtt")
	os.remove(autosub .. ".jpg")
end

mp.add_key_binding(key_binding, "autosub", getautosub)
