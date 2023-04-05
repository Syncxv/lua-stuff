gui_module = {}

syn_context_set(6)
local Roact = getrenv().require(game:GetService("CorePackages").Packages.Roact)
syn_context_set(6)

local coreGui = game:GetService("CoreGui")

function gui_module:init()
    local app = Roact.createElement("ScreenGui", {}, {
        HelloWorld = Roact.createElement("TextLabel", {
            Size = UDim2.new(0, 400, 0, 300),
            Text = "Hello, Roact!"
        })
    })
    Roact.mount(app, coreGui)
end

