-- settings
-- key_binding: press the key specified below 
--      to cycle between c64 filters below
local key_binding = "c"

local c64_filter_index = 0

function cycle_c64video()

    if c64_filter_index > 0 then
    -- insert the filter
    ret=mp.command(
        string.format(
            'vf del scale=160:100'
        )
    )
    mp.set_property("linear-scaling", "no")
    c64_filter_index = 0
    else
    -- insert the filter
    ret=mp.command(
        string.format(
            'vf add scale=160:100'
        )
    )
    mp.set_property("linear-scaling", "yes")
    c64_filter_index = 1
    end
end

mp.add_key_binding(key_binding, "c64video", cycle_c64video)
