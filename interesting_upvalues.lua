
local shared = getrenv().shared

local hri = shared.require("HudRadarInterface")
local fireShot = hri.fireShot

print(fireShot)

-- retrieve the u18 table from the fireShot function
local upvalues = debug.getupvalues(fireShot)
local u18
for i, upvalue in ipairs(upvalues) do
    if type(upvalue) == "table" and next(upvalue) ~= nil and type(next(upvalue)) == "userdata" then
        u18 = upvalue
        break
    end
end

for i,v in pairs(u18) do

		print(i, v)

		v:show()

end