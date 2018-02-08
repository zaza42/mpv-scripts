--
-- mpv bring back slash in title v0.5.3
--   ( copy me to ~/.config/mpv/scripts/ )
--
-- required binaries:
-- youtube-dl   - https://youtube-dl.org/
-- xdotool      - https://www.semicomplete.com/blog/projects/xdotool/
-- xseticon     - http://www.leonerd.org.uk/code/xseticon/
--      (debian - http://packages.leonerd.org.uk/dists/unstable/ )
-- jq           - https://github.com/stedolan/jq
-- luasocket
--

local utils = require 'mp.utils'
local msg = require 'mp.msg'
local patched = 1

youtube = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlz" ..
"AAALEwAACxMBAJqcGAAAASpJREFUOI3Fj7FKAwEQRN+ud7nLiUlIIXikDwiS3iLp9ENsrvYLtBFS" ..
"CfmBfMHVYhtsbWwsrVKqJEjMJWHXRkTCRSQITjkzOzML/w15bLf3oji+Vvdjc28o7KIaGYQKCmBg" ..
"CkvM5gYz4FVE7mI4D6pxfAGcIYKKfCXrt5bPoAjVSKEOHACHBTyrw8m28w1O1SEtE/cHA4JW68cA" ..
"hVQxq5WJ1W6XNM9pZBkSReULzGqqqsGmBoki6llGmudUe70yS0XL2FK4l9KBma02rfCiYDIcMh0O" ..
"8aIosywCVKdAc115H4146fdZjccbR6nqVJ46nQeBo1+9sQaDewVutzkGEPebIFkuL2dhWBGzLiJN" ..
"d09QjQVCgxBAYeWwwGwu8IbIxEVGO0lytW353+EDEcdb/8vRttIAAAAASUVORK5CYII="
facebook = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBI" ..
"WXMAAA3XAAAN1wFCKJt4AAABp0lEQVQ4y5WTPWtUQRSGn7l37r0M7qIJQrSwyIKdaLFIFBHsNSpY" ..
"iZ0gqcTKYkGwDGppIWns7Az4C8RGREVsJWWw3mxMsnM/ZuZYrLt3sx/InmrOvOc8c15mRrVuvXwi" ..
"IpsiwbBAKBVZpVRHrd580b98dc0sn2pi0pgsiUh0RBIrlFIIQgjgfKCoAnnpsaWn2zvg57fvVosE" ..
"c7Jp+LW7t8gAtM42EAlGA6SxIMHNLFxqpty5co7rF1ZYPdPgMHfcfv4Rkwx0DaAjIfjZgGf327TP" ..
"nwZg76AgTWKCd2Ra1YCI+YCLrWUAHr76xM7vfZQCkcHUI4AiTFn4/Presfzt0xsAXHu8PWiMxyxI" ..
"8HMnmIxhXcTYBM65KcDaxjsAvm49OJaP3oGEGlCV1dxbGMak7oOvAXlZ/tfCpF5VVQ3o24LgHRt3" ..
"23MBj9YvjdZbH36QF+U4IEe8Q/75mmlhTBPvsLaoAUd9SwiON++/TDXO2hseOgTY/T9HZqmRccKk" ..
"mCzBZAlZqtFxRBxHKCCI4L1QVI6ycnR7hwBWK+h0e/lmt5cv9J0Bq6DzF87Qyjqp0GJ2AAAAAElF" ..
"TkSuQmCC"
twitch = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBI" ..
"WXMAAA7DAAAOwwHHb6hkAAAApUlEQVQ4y2P8//8/AwMDA0Oq0zIIg0TAxMDAwHB8932yNDMwMDAw" ..
"/v//H8X22fuiiNKY6rQM4QJKAF4DDm+9A7cJmU20ARS7gC4GsOCTtPVWYbD1VsFgU+yCLYuvkG/A" ..
"lsVXGDbOv8TAwMDA0LrIF9MLyFEFS1TYoq91kS+DmAwvIxOxKQ6bZoJeIKQZnhewaEQRzG62YzCw" ..
"lmEkKx3g08zAwMAAAL2DN6b39LbLAAAAAElFTkSuQmCC"
nicovideo = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJN" ..
"AAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAWlBMVEUAAAALBQULBQULBQUL" ..
"BQULBQULBQULBQUAAAALBQUAAAAAAAAAAAALBQULBQUlIiI4MzMLBQVbV1dfW1tXUlINDQ0GAQEL" ..
"BQULBQWNiYmppqYGAQELBQX///8+nAgGAAAAGXRSTlMAM0RV7iLdd2aIMyKquxGq7szd3d3d3apm" ..
"rrtdgAAAAAFiS0dEHesDcZEAAAAHdElNRQfcCQQEOTLqAPc0AAAAZklEQVQY04WOSRKAIAwEE5Co" ..
"uO8K/P+dRi0F8WAfpmq65jAADAqfJzJBAEXpIyAjVJTfTWtdlESVQsSae7MZY1rrEsd0LHoXwmL4" ..
"FWMspljMNhJk7Vss4eD4AUJSJ8SV9XV+lT4/7CTGDlT+wIUFAAAAJXRFWHRkYXRlOmNyZWF0ZQAy" ..
"MDE4LTAyLTA3VDE2OjAwOjQxKzAxOjAw7RzbywAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMi0wOS0w" ..
"NFQwNDo1Nzo1MCswMjowMJ7d5OsAAAAASUVORK5CYII="
indavideo = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJN" ..
"AAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAe1BMVEXeMSjdMCjcLyjcgH3+" ..
"/PznurjaLifqxsb////aNS/YLSfWRkHltrXWWVXWLCfUVFHdl5bVWlfUKif8+Pj9+/vSKSbQKCbO" ..
"JibOLCzMJSX9+vrbmpvVgYHKIyXoxsb58/PIIiXJP0Hox8f//v737e3QcnTGISXEICTDHyRix4+h" ..
"AAAAAWJLR0QIht6VegAAAAd0SU1FB94CBg4QF3jEYd8AAABpSURBVBjTXcrJEoJQEEPRMCgNCsqM" ..
"KDKj//+FvErv+qxupQJYngGfgvCi4eNKkUishYRu91QjQUaPZ66RoaBSKo0CNYmIRo2G3KDRoCU3" ..
"dFp4US/y/rAw0NddRhYmmpd121k4DPwM/I0TWq0TTsn4eO4AAAAldEVYdGRhdGU6Y3JlYXRlADIw" ..
"MTgtMDItMDVUMTI6MDQ6MjErMDE6MDBlgT3DAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTAyLTA2" ..
"VDE0OjE2OjIzKzAxOjAwKvdFhAAAAABJRU5ErkJggg=="
streamerable = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABU1BMVEUPkPoPkPoPkPoPkPoPkPoP" ..
"kPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoNj/oPkPoNj/oNj/qExv0PkPpruvwPkPornfoVk/op" ..
"nPpnufwPkPqExv0Nj/oPkPoNj/oPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoO" ..
"j/opnPsVk/oMjvoOkPoTkfo6pPsblfo3ovva7v7////v9/5Sr/whmPry+f5htvze8P7W7P5itvyl" ..
"1v0imPu84P3o9P50v/zN6P73+/8lmvs8pfs+pfsKjvr9/v9EqfsNj/oom/v8/v9nufxAp/tJq/sQ" ..
"kPrb7v6t2f0IjPoclvr6/f9luPwUkvrp9f7h8f5ruvy/4f4kmftpuvwxoPum1v32+/8jmfpMrPvu" ..
"9/7z+f9UsPs7pPv8/f/4/P9oufwalfpDqPsMj/ounvtVsPsnm/oX4FZeAAAAAXRSTlMAQObYZgAA" ..
"AAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAACzSURBVBgZBcExS8NQGEDRe19SzPcq" ..
"dFBwsISiWR39/wiODk4OQgliRUToYCTE5mk9RwBUdAYQ8OQKgN4RhNMWAIDXgQo6AABYzVNNIKpq" ..
"KeLZhY2qxdrv3486cWxUVV2+pbRnfVju8xQREaEJgtjEZc59REAt0anbzlv1aJIh5+e4yfkp4kGr" ..
"v8W0OF8/tvfXbX1X3j8lbwAAgK9dxTytAAAYdlRwyGMDwFheQAA61Z8e4B9zfC+56atCOAAAAABJ" ..
"RU5ErkJggg=="
myoutfile = "/tmp/mpv-favicon.png"

local ltn12 = require "ltn12"
local mime = require "mime"

function writebase64(mystring)
ltn12.pump.all(
  ltn12.source.string(mystring),
  ltn12.sink.chain(
    mime.decode("base64"),
    ltn12.sink.file(io.open(myoutfile,"w"))
  )
)
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return string.sub(s, 0, -2) -- Use string.sub to trim the trailing newline.
end

function get_uploader(url,uploader)
  return os.capture(
    'youtube-dl -j "' .. url .. '"| jq -r .' .. uploader)
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function on_loaded()
    local title = mp.get_property("media-title")
    if ( string.find(title, '/') )
    then
	msg.warn("title on_preload matched")
	cmd = { args = {"sleep", "0.1"} }
	utils.subprocess(cmd)
	mp.set_property("file-local-options/title", title)
    end

    filepath = mp.get_property("path")

    if (filepath:find("http") ~= 1) then return end
    msg.warn("http matched " .. filepath)

    if ( string.find(filepath, 'facebook.com') ) then writebase64(facebook)
    elseif ( string.find(filepath, 'yout') ) then writebase64(youtube)
	json_uploader = "uploader"
    elseif ( string.find(filepath, '^https?://[www.]*twitch') ) then writebase64(twitch)
	json_uploader = "uploader"
    elseif ( string.find(filepath, '^https?://[www.]*nicovideo.jp') ) then writebase64(nicovideo)
	json_uploader = "uploader"
    elseif ( string.find(filepath, 'indavideo') ) then writebase64(indavideo)
    elseif ( string.find(filepath, 'streamable.com') ) then writebase64(streamable)
    end
    if (file_exists(myoutfile))
    then
	msg.warn("website icon use")
        cmd = { args = {"sh", "-c", 
	    "xseticon -id $(xdotool search --sync --onlyvisible --pid $PPID) " .. myoutfile } }
        utils.subprocess(cmd)
	if (json_uploader) and (patched == nil)
	then
	    uploader = get_uploader(filepath,json_uploader)
	    if (uploader)
	    then
		local newtitle = title .. ' @' .. uploader
		msg.warn("filepath:", filepath, "uploader: ", uploader, "newtitle: ", newtitle)
		mp.set_property("file-local-options/title", newtitle)
		mp.set_property("file-local-options/force-media-title", newtitle)
	    end
	end
	os.remove(myoutfile)
    end
end

mp.register_event('file-loaded', on_loaded)
