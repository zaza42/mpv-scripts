-- settings
-- key_binding: press the key specified below
--      to toggle loudnorm filters below
local key_binding = "n"

local loudnorm_filter_index = 0

function cycle_loudnorm()
    ret=mp.command(
        string.format(
            'af toggle lavfi=[loudnorm=I=-16:TP=-3:LRA=4,aresample=48000]'
        )
    )
end

mp.add_key_binding(key_binding, "loudnorm", cycle_loudnorm)
