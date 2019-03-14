--
-- originally from https://gist.github.com/bitingsock/f9a87ea158035d4a36899b559d611228
-- ported to Linux by DC-1
--
-- Use --prefetch-playlist=yes in mpv.conf
--

local utils = require 'mp.utils'
local msg = require 'mp.msg'

--local ytdlPath = mp.find_config_file("youtube-dl")
local ytdlPath = "youtube-dl"
local fileDuration = 0
local function check_position()
	if fileDuration==0 then
		mp.unobserve_property(check_position)
		return
	end
	local demuxEndPosition = mp.get_property("demuxer-cache-time")
	if demuxEndPosition and 
		fileDuration > 0 and 
		(fileDuration - demuxEndPosition < 10) and 
		(mp.get_property("playlist-pos-1")~=mp.get_property("playlist-count")) then
		local next = tonumber(mp.get_property("playlist-pos")) + 1
		local nextFile = mp.get_property("playlist/"..tostring(next).."/filename")
		if nextFile then
			local ytdl = {}
			ytdl.args = {ytdlPath, "-f "..mp.get_property("ytdl-format"), "-e", "-g", nextFile}
			local res = utils.subprocess(ytdl)
			msg.warn("youtube-prefetch")
			local lines = {}
			for s in res.stdout:gmatch("[^\n]+") do
				table.insert(lines, s)
			end
			local audioURL = ""
			if lines[3] then 
				audioURL = ',audio-file=['..lines[3]..']'
			end
			if lines[1] and lines[2] then
				mp.commandv("loadfile", lines[2], "append", 'force-media-title=['..lines[1]..']'..audioURL)
				mp.commandv("playlist_move", mp.get_property("playlist-count") - 1 , next)
				mp.commandv("playlist_remove", next + 1)
			end
			mp.unobserve_property(check_position)
		end
	end
end
local function observe()
	if mp.get_property("path"):find("://", 0, false) then
		fileDuration = mp.get_property("duration", 0)
		fileDuration = tonumber(fileDuration)
		mp.observe_property("time-pos", "native", check_position)
	end
end
mp.register_event("file-loaded", observe)