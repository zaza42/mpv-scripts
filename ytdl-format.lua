local utils = require 'mp.utils'
local msg = require 'mp.msg'


mp.add_hook("on_load", 9, function ()
    local url = mp.get_property("path")
--    if (url:find("http://www.youtu") == 1)  or (url:find("https://www.youtu") == 1)
--        or (url:find("http://youtu.be") == 1)  or (url:find("https://youtu.be") == 1)
    if ( string.find(url, 'youtu') )
    then
        msg.warn("youtube on_load matched")
        mp.set_property("options/ytdl-format", "bestvideo[height<=1080]+bestaudio")
--        msg.warn(mp.get_property("stream-open-filename"))
    end
end)

