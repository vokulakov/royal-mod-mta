addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), function(station)
	local veh = getPedOccupiedVehicle(localPlayer) 
    if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end
	if station ~= 0 then cancelEvent() end
	if isElement(sound) then destroyElement(sound) return end
	sound = playSound3D("http://air.radiorecord.ru:8101/rr_320", 0, 0, 0)
	setSoundVolume(sound, 1.0)
	setSoundMaxDistance(sound, 100) 
	attachElements(sound, veh)
end)

addEventHandler ( "onClientPlayerVehicleEnter", getLocalPlayer(), function (vehicle, seat)
	setRadioChannel(0)
end)

addEventHandler ( "onClientVehicleStartExit", getRootElement (), function (player)
end)

addCommandHandler('hud', function()
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	triggerEvent("rmta_showui.setVisiblePlayerUI", root, not PLAYER_UI['all'])
end)