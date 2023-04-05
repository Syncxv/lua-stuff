local esp = require("esp")


function gui_init()
    esp.esp_core:init()
    local UILibrary = require("gui")

    local MainUI = UILibrary.Load("Hi there")
    esp:gui_init(MainUI)
end
gui_init()