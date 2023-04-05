color_module = {}

function color_module.getTeamColor(p, plr)
    if p.Team == plr.Team then return Color3.new(0, 1, 0) end

    return Color3.new(1, 0, 0)
end

