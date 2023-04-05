local esp = require("esp")
local hitbox = require("hitbox")

function gui_init()
    esp.esp_core:init()
    hitbox:init()
    local UILibrary = require("gui")

    local MainUI = UILibrary.Load("Hi there")
    esp:gui_init(MainUI)
    hitbox:gui_init(MainUI)
end
gui_init()