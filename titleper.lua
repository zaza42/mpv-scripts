local utils = require 'mp.utils'
local msg = require 'mp.msg'

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return string.sub(s, 0, -2) -- Use string.sub to trim the trailing newline.
end

function get_uploader(url)
  return os.capture(
--    'youtube-dl --get-filename -o "%(uploader)s" "' .. url .. '"')
    'youtube-dl -j "' .. url .. '" |jq -r .uploader')
end

function on_loaded()
    local title = mp.get_property("media-title")
    if ( string.find(title, '/') )
    then
	msg.warn("title on_preload matched")
	cmd = { args = {"sleep", "0.1"} }
	utils.subprocess(cmd)
--	cmd = { args = {"xsettitle.sh", title} }
--	utils.subprocess(cmd)
	mp.set_property("file-local-options/title", title)
    end

    filepath = mp.get_property("path")
    if (filepath:find("http") ~= 1) then return end
    msg.warn("http matched " .. filepath:find("http"))

    if ( string.find(filepath, 'facebook') )
    then
	iconfile = "/home/DC-1/.icons/facebook.png"
    end
    if ( string.find(filepath, 'yout') )
    then
	iconfile = "/home/DC-1/.icons/youtube.png"
    end
    if ( string.find(filepath, 'twitch') )
    then
	iconfile = "/home/DC-1/.icons/twitch.png"
    end
    if ( string.find(filepath, 'indavideo') )
    then
	iconfile = "/home/DC-1/.icons/indavideo.png"
    end
    if ( string.find(filepath, 'index.hu') )
    then
	iconfile = "/home/DC-1/.icons/index.png"
    end
    if ( string.find(filepath, 'streamable.com') )
    then
	iconfile = "/home/DC-1/.icons/streamable.png"
    end
    if (iconfile)
    then
	msg.warn("website icon use")
        cmd = { args = {"xseticon.sh", iconfile } }
        utils.subprocess(cmd)
	if ( string.find(filepath, 'youtu') )
	then
--	    cmd = { args = {"sleep", "2"} }
--	    utils.subprocess(cmd)
	    uploader = get_uploader(filepath)
	    if (uploader)
	    then
		local newtitle = title .. ' @' .. uploader
		msg.warn("filepath:", filepath, "uploader: ", uploader, "newtitle: ", newtitle)
		mp.set_property("file-local-options/title", newtitle)
		mp.set_property("file-local-options/force-media-title", newtitle)
	    end
	end
    end
end

mp.register_event('file-loaded', on_loaded)
