--
-- download youtue auto-generated english subtitles
--   ( copy me to ~/.config/mpv/scripts/ )
--
-- required binaries:
-- mpv          - http://mpv.io
-- youtube-dl   - https://youtube-dl.org/
-- ffmpeg       - https://ffmpeg.org/
--
local key_binding = "ctrl+v"
local utils = require 'mp.utils'
local msg = require 'mp.msg'

function getautosub()
	filepath = mp.get_property("path")
	if (filepath:find("http") ~= 1) then return end
--	msg.warn("download autosub")
        mp.osd_message("downloading auto-generated subtitles", osd_time)

        cmd = { args = { 'sh', '-c',
	    "youtube-dl --skip-download --write-auto-sub -o /dev/shm/$PPID.vtt '" .. filepath .. "'"} }
        utils.subprocess(cmd)
        cmd = { args = { 'sh', '-c',
	    "ffmpeg -i /dev/shm/$PPID.en.vtt /dev/shm/titleper.auto.srt"} }
        utils.subprocess(cmd)
	mp.command("sub_add /dev/shm/titleper.auto.srt")
        cmd = { args = { 'sh', '-c',
	    "rm /dev/shm/titleper.auto.srt /dev/shm/$PPID.*"} }
        utils.subprocess(cmd)
end

mp.add_key_binding(key_binding, "autosub", getautosub)
