local GunFunctions = {}

function GunFunctions.damage(character, amount)
	character:FindFirstChild("Humanoid").Health -= amount
end

local handle = script.Parent.Parent.Handle

local function createBeam(origin, direction, position)
	if position == nil then
		position = direction
	end
	
	local TweenService = game:GetService("TweenService")
	local distance = (origin - direction).Magnitude
	print(distance/10)
	if distance/10 < 108 then
		position = direction
	end
	local bullet = game:GetService("ReplicatedStorage"):FindFirstChild("gun"):WaitForChild("bullet"):Clone()
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)

	-- create two conflicting tweens (both trying to animate part.Position)
	local tween1 = TweenService:Create(bullet, tweenInfo, {Position = position * 1})
	bullet.CFrame = CFrame.lookAt(handle.Position, direction) --CFrame.lookAt(origin, direction)*CFrame.new(0, 0, -distance/2)
	bullet.Size = Vector3.new(0.125, 0.125, 7)
	bullet.Parent = game.Workspace	
	
	bullet.Activated.WaitTime.Value = script.Parent.Parent.reloadtime.Value
	bullet.Activated.Value = true
	tween1:Play()
	tween1.Completed:Connect(function()
		bullet:Destroy()
	end)
	--[[
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.Size = Vector3.new(0.1, 0.1, distance)
	p.CFrame = CFrame.lookAt(origin, position)*CFrame.new(0, 0, -distance/2)
	p.Parent = workspace
	--]]
end

local fireSound = script.Parent.Parent.fire
function GunFunctions.shoot(player, Origin, Direction)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {game.Workspace:FindFirstChild(player.Name):GetChildren(), script.Parent.Parent.Handle, game:GetService("ReplicatedStorage").gun.bullet}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	local result = workspace:Raycast(Origin, Direction, params)
	local Position = nil
	
	if result ~= nil then
		Position = result.Position
	end
	
	createBeam(Origin, Direction, Position)
	fireSound:Play()
	if result then
		if result.Instance.Parent == nil then return end
		if not result.Instance.Parent:IsA("Model") then return end
		
		if result.Instance.Parent:FindFirstChild("Humanoid") then
			local headshotDamage = script.Parent.Parent.damage.headshot.Value
			local bodyshotDamage = script.Parent.Parent.damage.Value
			if result.Instance.Name == "Head" then
				GunFunctions.damage(result.Instance.Parent, headshotDamage)
			else
				GunFunctions.damage(result.Instance.Parent, bodyshotDamage)
			end
		end
	end
end

local reloadSound = script.Parent.Parent.reload
function GunFunctions.reload()
	if not script.Parent.Parent.CanReload.Value then return end
	script.Parent.Parent.CanShoot.Value = false
	script.Parent.Parent.CanReload.Value = false
	if fireSound.IsPlaying then
		wait(1)
	end
	reloadSound:Play()
	local rounds = script.Parent.Parent.ammo.rounds
	rounds.Value = script.Parent.Parent.ammo.Value
	wait(reloadSound.TimeLength)
	script.Parent.Parent.CanReload.Value = true
	script.Parent.Parent.CanShoot.Value = true
end

return GunFunctions