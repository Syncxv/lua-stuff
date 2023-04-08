if not game:IsLoaded() then
    game.Loaded:Wait()
end


local esp = require("esp")
local hitbox = require("hitbox")
local aimbot = require("aimbot")
local UILibrary = require("gui")

function gui_init()
    esp:init()
    hitbox:init()
    aimbot:init()

    local MainUI = UILibrary.Load("Hi there")
    aimbot:gui_init(MainUI)
    esp:gui_init(MainUI)
    hitbox:gui_init(MainUI)
end
gui_init()