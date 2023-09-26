addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), function(station)
	local veh = getPedOccupiedVehicle(localPlayer) 
    if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end
	if station ~= 0 then cancelEvent() end
	if isElement(sound) then destroyElement(sound) return end
	sound = playSound("http://air.radiorecord.ru:8101/rr_320")
end)

addEventHandler ( "onClientPlayerVehicleEnter", getLocalPlayer(), function (vehicle, seat)
	setRadioChannel(0)
end)

addEventHandler ( "onClientVehicleStartExit", getRootElement (), function (player)
	if player == getLocalPlayer () then
		if isElement(sound) then 
			destroyElement(sound) 
		end
	end
end)