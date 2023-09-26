local bindLight = "l"
local bindEngine = "k"

function setOverrideVehicleLight(player, key, keyState, vehicle)
	if (getVehicleOverrideLights(vehicle) ~= 2) then
        setVehicleOverrideLights(vehicle, 2)
    else
        setVehicleOverrideLights(vehicle, 1)
    end
end

function setEngineVehicleState(player, key, keyState, vehicle)
	local state = getVehicleEngineState(vehicle)
	setVehicleEngineState (vehicle, not state)
	if not state == false then 
		if getElementData(vehicle, "cruiseSpeedEnabled" ) then
			triggerClientEvent (player, "toggleCruiseSpeed", player) 
		end
	end
end

function enterVehicle ( thePlayer, seat, jacked )
	local veh = getPedOccupiedVehicle(thePlayer) 
    if not veh then return end
	if seat ~= 0 then return end
	bindKey (thePlayer, bindLight, "down", setOverrideVehicleLight, veh)
	bindKey (thePlayer, bindEngine, "down", setEngineVehicleState, veh)
end
addEventHandler ( "onVehicleEnter", getRootElement(), enterVehicle)

function exitVehicle ( thePlayer, seat, jacked )
	if getElementData(source, "cruiseSpeedEnabled" ) and seat == 0 then
		triggerClientEvent (thePlayer, "toggleCruiseSpeed", thePlayer) 
	end
	unbindKey (thePlayer, bindLight, "down", setOverrideVehicleLight)
	unbindKey (thePlayer, bindEngine, "down", setEngineVehicleState)
end
addEventHandler ( "onVehicleStartExit", getRootElement(), exitVehicle)

addEventHandler("onElementDestroy",  getRootElement(), function()
	if getElementType(source) == 'vehicle' then
		local player = getVehicleOccupant (source)
		if not player then return end
		unbindKey (player, bindLight, "down", setOverrideVehicleLight)
		unbindKey (player, bindEngine, "down", setEngineVehicleState)
	end
end)
