script_version("1.0.0")

require 'moonloader'

function main()
	if 
	local isCamPlacementNeeded, shouldCamBeBehindPlayer = false, true
	
	local function isSwitchKeyPressed()
		return (isKeyDown(32) and not (sampIsChatInputActive ~= nil and sampIsChatInputActive()))
	end
	
	-- Mouse control
	lua_thread.create(function ()
		local x, y
		
		while true do
			if isCharInFlyingVehicle(PLAYER_PED) then
				while isCharInFlyingVehicle(PLAYER_PED) do
					x, y = getPcMouseMovement()
					
					if x ~= 0 or y ~= 0 then
						isCamPlacementNeeded = false
						
						while isCharInFlyingVehicle(PLAYER_PED) and not isCamPlacementNeeded do wait(0) end
					end
					
					wait(0)
				end
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
	
	while true do
		while isCharInFlyingVehicle(PLAYER_PED) do
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