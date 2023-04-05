local esp = require("esp")


function gui_init()
    esp.esp_core:init()
    local UILibrary = require("gui")

    local MainUI = UILibrary.Load("Hi there")
    local FirstPage = MainUI.AddPage("ESP")

    local FirstLabel = FirstPage.AddLabel("ESP")
    local ESPToggle = FirstPage.AddToggle("Enabled", esp.esp_core.enabled, function(Value)
        esp.esp_core.enabled = Value
    end)
    local VisibleCheckToggle = FirstPage.AddToggle("Visible Check", esp.esp_core.visible_check, function(Value)
        esp.esp_core.visible_check = Value
    end)
    local MaxDistanceSlider = FirstPage.AddSlider("Max Distance", {Min = 0, Max = 2000, Def = esp.esp_core.max_distance}, function(Value)
        esp.esp_core.max_distance = Value
    end)
    local FirstPicker = FirstPage.AddColourPicker("ESP Color", esp.esp_core.color, function(Value)
        esp.esp_core.color = Value
        for _, v in pairs(esp.esp_core.esp_table) do
            v:SetColor(Value)
        end
    end)
end
gui_init()