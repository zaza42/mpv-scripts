--
-- download youtube auto-generated english subtitles v0.2
--   ( copy me to ~/.config/mpv/scripts/ )
--
-- required binaries:
-- youtube-dl   - https://youtube-dl.org/
--
local key_binding = "ctrl+v"
--local autosub = "/dev/shm/mpv-autosub"

local utils = require 'mp.utils'
local msg = require 'mp.msg'

function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read "*a")
  f:close()
  return string.sub(s, 0, -2) -- Use string.sub to trim the trailing newline.
end

function get_pid()
  return os.capture( 'sh -c "echo $PPID"')
end

local platform = nil --set to 'linux', 'windows' or 'macos' to override automatic assign
if not platform then
  local o = {}
  if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
    platform = 'windows'
  elseif mp.get_property_native('options/input-app-events', o) ~= o then
    platform = 'macos'
  else
    platform = 'linux'
  end
end

function getautosub()
	if platform == 'linux' then
	    msg.warn("ytdl-autosub: Linux required")
	    return
	end
	filepath = mp.get_property("path")
	if (filepath:find("http") ~= 1) then return end
	msg.warn("download autosub")
	local autosub = "/dev/shm/" .. get_pid()
        mp.osd_message("downloading auto-generated subtitles", osd_time)

        cmd = { args = { 'sh', '-c',
	    "youtube-dl --skip-download --write-auto-sub -o " .. autosub ..
	    " '" .. filepath .. "'"} }
        utils.subprocess(cmd)
	mp.command("sub_add " .. autosub .. ".en.vtt")
	os.remove(autosub .. ".en.vtt")
	os.remove(autosub .. ".jpg")
end

mp.add_key_binding(key_binding, "autosub", getautosub)
