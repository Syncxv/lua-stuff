local PlayerDot = {}

PlayerDot.__index = PlayerDot

local PlayerStatusInterface = shared.require("PlayerStatusInterface")
local HudScreenGui = shared.require("HudScreenGui")
local UIScale = HudScreenGui.getUIScale()
local ScreenGui = HudScreenGui.getScreenGui()
local Destructor = shared.require("Destructor")
local CameraInterface = shared.require("CameraInterface")
local CharacterInterface = shared.require("CharacterInterface")
local Vector = shared.require("vector")
local ReplicationInterface = shared.require("ReplicationInterface")
local LocalPlayer = game:GetService("Players").LocalPlayer
local GameRoundInterface = shared.require("GameRoundInterface")
local Physics = shared.require("physics")
local PublicSettings = shared.require("PublicSettings")
local CurrentCamera = workspace.CurrentCamera

function PlayerDot.new(firearmObject)
	local self = setmetatable({}, PlayerDot)

	self._destructor = Destructor.new()
	self._firearmObject = firearmObject
	self._size = 0.009259259259259259
	self._dot = Instance.new("Frame")
	self._dot.Size = UDim2.new(self._size * UIScale, 0, self._size * UIScale, 0)
	self._dot.BackgroundColor3 = Color3.new(1, 1, 0.7)
	self._dot.SizeConstraint = "RelativeYY"
	self._dot.BorderSizePixel = 0
	self._dot.Rotation = 45
	self._dot.Parent = ScreenGui.Main.ContainerActive
	self._destructor:add(self._dot)

	return self
end

function PlayerDot.Destroy(self)
	self._destructor:Destroy()
end

function PlayerDot.step(self)
	local activeCamera = CameraInterface.getActiveCamera("MainCamera")

	if not self._firearmObject:isAiming() then
		self._dot.BackgroundTransparency = 1
		return
	end

	local characterObject = CharacterInterface.getCharacterObject()

	if not characterObject or characterObject:getSpring("aimspring").p < 0.95 then
		self._dot.BackgroundTransparency = 1
		return
	end

	local players = game:GetService("Players"):GetPlayers()
	local cameraAngles = activeCamera:getAngles()
	local yxAngles = Vector.anglesyx(cameraAngles.x, cameraAngles.y)
	local dotSize = self._size / 2 * ScreenGui.AbsoluteSize.y
	local closestPlayerDot = nil
	local closestPlayerDotDotProduct = 0.995

	ReplicationInterface.operateOnAllEntries(function(player, entry)
		if player.TeamColor ~= LocalPlayer.TeamColor and entry:isAlive() then
			local cameraPosition = activeCamera:getCFrame().p
			local playerPosition, isPlayerPositionValid = ReplicationInterface.getEntry(player):getPosition()

			if isPlayerPositionValid and not workspace:FindPartOnRayWithWhitelist(Ray.new(cameraPosition, playerPosition - cameraPosition), GameRoundInterface.raycastWhiteList) then
				local trajectory = Physics.trajectory(cameraPosition, PublicSettings.bulletAcceleration, playerPosition, self._firearmObject:getWeaponStat("bulletspeed"))

				if trajectory then
					local dotProduct = trajectory.unit:Dot(yxAngles)

					if closestPlayerDotDotProduct < dotProduct then
						closestPlayerDotDotProduct = dotProduct
						closestPlayerDot = CurrentCamera:WorldToViewportPoint(cameraPosition + trajectory)
					end
				end
			end
		end
	end)

	if closestPlayerDot then
		self._dot.BackgroundTransparency = 0
		self._dot.Position = UDim2.new(0, closestPlayerDot.x / UIScale - dotSize, 0, closestPlayerDot.y / UIScale - dotSize);
		self._dot.Size = UDim2.new(self._size * UIScale, 0, self._size * UIScale, 0);
	else
		self._dot.BackgroundTransparency = 1;
	end;
end;
return PlayerDot;
