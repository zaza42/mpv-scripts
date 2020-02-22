-- settings
-- key_binding: press the key specified below
--      to toggle loudnorm filters below
local key_binding = "ctrl+n"

local loudnorm_filter_index = 0

function cycle_loudnorm()

    if loudnorm_filter_index > 0 then
    -- insert the filter
    ret=mp.command(
        string.format(
            'af remove lavfi=[loudnorm=I=-16:TP=-3:LRA=4,aresample=48000]'
        )
    )
    loudnorm_filter_index = 0
    else
    -- insert the filter
    ret=mp.command(
        string.format(
            'af add lavfi=[loudnorm=I=-16:TP=-3:LRA=4,aresample=48000]'
        )
    )
    loudnorm_filter_index = 1
    end
end

mp.add_key_binding(key_binding, "loudnorm", cycle_loudnorm)
