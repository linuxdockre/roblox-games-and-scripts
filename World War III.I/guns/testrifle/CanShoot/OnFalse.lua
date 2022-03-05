script.Parent.Changed:Connect(function()
	if script.Parent.Value == false then
		wait(script.Parent.Parent.reloadtime.Value)
		script.Parent.Value = true
	end
end)