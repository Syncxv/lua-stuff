local function createText(bruh, position)
    local text = Drawing.new("Text");

    text.Visible = true
    text.Transparency = 1
    text.ZIndex = 1
    text.Color = Color3.fromRGB(255, 255, 255);
    text.Position = position
    text.Text = bruh;
    coroutine.wrap(function()
        game.RunService.RenderStepped:Wait()
        text:Remove() --destroy after a frame because we make new part on frame
    end)()
    return text
end
