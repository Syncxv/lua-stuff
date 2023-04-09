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
    
    -- ill make it better later (maybe)
    local CreditsPage = MainUI.AddPage("Credits")

    CreditsPage.AddLabel("https://github.com/Syncxv/lua-stuff/tree/master/pf%20ui#credits", 10)

    CreditsPage.AddLabel("Aimbot", 14, Color3.new(1,0,0))
    CreditsPage.AddLabel("No idea#7972 (773953647289565204)")
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("Hitbox Expander",14, Color3.new(1,0,0))
    CreditsPage.AddLabel("The3Bakers#4565 https://discord.gg/vQQqcgBWCG")
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("ESP", 14, Color3.new(1,0,0))
    CreditsPage.AddLabel("me Aria#8171 (549244932213309442)")
    CreditsPage.AddLabel("Racist Dolphin")
    CreditsPage.AddLabel("No idea#7972 (773953647289565204)")
end
gui_init()