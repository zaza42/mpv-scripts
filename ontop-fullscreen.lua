--makes mpv disable ontop when fullscreen and re-enable it again when windowed
--please note that this won't do anything if ontop was not enabled before fullscreen

local was_ontop_f = false

mp.observe_property("fullscreen", "bool", function(name, value)
    local ontop_f = mp.get_property_native("ontop")
    if value then
        if ontop_f then
            mp.set_property_native("ontop", false)
            was_ontop_f = true
        end
    else
        if was_ontop_f and not ontop_f then
            mp.set_property_native("ontop", true)
        end
        was_ontop_f = false
    end
end)
