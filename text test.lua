local i = 1;
game.RunService.RenderStepped:Connect(function()
    local text = Drawing.new("Text");
    
    text.Visible = true
    text.Transparency = 1
    text.ZIndex = 1
    text.Color = Color3.fromRGB(255, 255, 255);
    text.Position = Vector2.new(game.Players.LocalPlayer:GetMouse().ViewSizeX - 50, 0);
    text.Text = "HI " .. tostring(i);
    coroutine.wrap(function()
                    game.RunService.RenderStepped:Wait()
                    text:Remove() --destroy after a frame because we make new part on frame
                end)()
    i = i + 1;

end)