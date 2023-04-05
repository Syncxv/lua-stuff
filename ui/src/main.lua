local esp = require("esp")
local hitbox = require("hitbox")
local aimbot = require("aimbot")

function gui_init()
    esp.esp_core:init()
    hitbox:init()
    aimbot:init()
    local UILibrary = require("gui")

    local MainUI = UILibrary.Load("Hi there")
    aimbot:gui_init(MainUI)
    esp:gui_init(MainUI)
    hitbox:gui_init(MainUI)
end
gui_init()