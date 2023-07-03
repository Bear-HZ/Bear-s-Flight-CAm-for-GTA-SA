script_version("1.0.2")

require 'moonloader'

function main()
	local isCamPlacementNeeded, shouldCamBeBehindPlayer = false, true
	
	local function isSwitchKeyPressed()
		return (isKeyDown(32) and not (sampIsChatInputActive ~= nil and sampIsChatInputActive()) and not (sampIsDialogActive ~= nil and sampIsDialogActive()))
	end
	
	-- Mouse control
	lua_thread.create(function ()
		local x, y
		
		while true do
			while isCharInFlyingVehicle(PLAYER_PED) do
				x, y = getPcMouseMovement()
				
				if x ~= 0 or y ~= 0 then
					isCamPlacementNeeded = false
					
					while isCharInFlyingVehicle(PLAYER_PED) and not isCamPlacementNeeded do wait(0) end
				end
				
				wait(0)
			end
			
			wait(50)
		end
	end)
	
	-- Key activations
	lua_thread.create(function ()
		while true do
			while isCharInFlyingVehicle(PLAYER_PED) do
				if isSwitchKeyPressed() then
					while isCharInFlyingVehicle(PLAYER_PED) and isSwitchKeyPressed() do wait(0) end
					
					if isCamPlacementNeeded then
						shouldCamBeBehindPlayer = not shouldCamBeBehindPlayer
					else
						shouldCamBeBehindPlayer = true
						isCamPlacementNeeded = true
					end
				end
				
				wait(0)
			end
			
			wait(50)
		end
	end)
	
	-- Cam placement
	while true do
		while isCharInFlyingVehicle(PLAYER_PED)
		and isCharSittingInAnyCar(PLAYER_PED) -- Added in 1.0.1; ensures that the player character isn't in the process of stepping out of the vehicle
		do
			if isCamPlacementNeeded then
				if shouldCamBeBehindPlayer then
					setCameraBehindPlayer()
				else
					setCameraInFrontOfPlayer()
				end
			end
			
			wait(0)
		end
		
		if isCamPlacementNeeded then isCamPlacementNeeded = false end
		
		wait(50)
	end
end
