local GunFunctions = require(script:WaitForChild("GunFunctions"))
local UserInputService = game:GetService("UserInputService")

local tool = script.Parent
local ammo = tool.ammo
local rounds = ammo.rounds

local aiming = false

rounds.Changed:Connect(function()
	if rounds.Value == 0 then
		GunFunctions.reload()
	end
end)

UserInputService.InputBegan:Connect(function(InputObject, gameProcessedEvent)
	if gameProcessedEvent then return end
	if InputObject.KeyCode == Enum.KeyCode.R then
		if script.Parent.Enabled and rounds.Value < ammo.Value then
			GunFunctions.reload()
		end
	end
end)

local debounce = script.Parent.CanShoot
local function resetDebounce(reloadtime)
	wait(reloadtime)
	debounce.Value = true
end

script.Parent.Equipped:Connect(function(Mouse)
	local player = game.Players.LocalPlayer
	player.PlayerGui:FindFirstChild("GunGui").Enabled = true
	player.PlayerGui:FindFirstChild("GunGui").Frame.Ammo.Text = rounds.Value.."/"..ammo.Value
	Mouse.Button1Down:Connect(function()
		if debounce.Value then
			debounce.Value = false
			local origin = script.Parent.Handle.Position
			local mousePos = Vector2.new(
				workspace.CurrentCamera.ViewportSize.X / 2, 
				workspace.CurrentCamera.ViewportSize.Y / 2 - game:GetService("GuiService"):GetGuiInset().Y/2	
			)
			local raycast = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
			--local direction = (mousePos - origin).Unit * 1000
			if rounds.Value > 0 then
				GunFunctions.shoot(game.Players.LocalPlayer, raycast.Origin, raycast.Direction*1000)
				rounds.Value -= 1
			end
			player.PlayerGui:FindFirstChild("GunGui").Frame.Ammo.Text = rounds.Value.."/"..ammo.Value
			resetDebounce(script.Parent.reloadtime.Value)
		end
	end)
	
	Mouse.Button2Down:Connect(function()
		aiming = true
	end)
	
	Mouse.Button2Up:Connect(function()
		aiming = false
	end)
end)