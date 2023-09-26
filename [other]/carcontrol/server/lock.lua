local bindLoock = "j"

function initCarLocks ()
	local players = getElementsByType ( "player" )
	for k, p in ipairs(players) do
		removeElementData ( p, "cl_ownedvehicle" )
		bindKey ( p, bindLoock, "down", doToggleLocked )
	end

	local vehicles = getElementsByType ( "vehicle" )
	for k,v in ipairs(vehicles) do
		removeElementData ( v, "cl_vehicleowner" )
		removeElementData ( v, "cl_vehiclelocked" )
		removeElementData ( v, "cl_enginestate" )
		setVehicleLocked ( v, false )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), initCarLocks )
addEventHandler ( "onResourceStop", getResourceRootElement ( getThisResource () ), initCarLocks )

function cl_PlayerJoin ()
	bindKey ( source, bindLoock, "down", doToggleLocked )
end
addEventHandler ("onPlayerJoin", getRootElement(), cl_PlayerJoin)

function cl_PlayerQuit ()
	local ownedVehicle = getElementData ( source, "cl_ownedvehicle" )
	if (ownedVehicle ~= false) then
		cl_RemoveVehicleOwner ( ownedVehicle )
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), cl_PlayerQuit)

function cl_PlayerWasted ()
	local ownedVehicle = getElementData ( source, "cl_ownedvehicle" )
	if (ownedVehicle ~= false) then
		cl_RemoveVehicleOwner ( ownedVehicle )
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), cl_PlayerWasted)

function cl_VehicleStartEnter ( enteringPlayer, seat, jacked )
	local theVehicle = source
	local theOwner
	if ( getElementData ( theVehicle, "cl_vehiclelocked" ) == true ) then
		theOwner = getElementData ( theVehicle, "cl_vehicleowner" )
		if theOwner ~= false and theOwner ~= enteringPlayer then
		end
	end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), cl_VehicleStartEnter)

function cl_PlayerDriveVehicle ( player, seat, jacked )
	if ( seat == 0 ) then
		oldVehicle = getElementData ( player, "cl_ownedvehicle" )
		if ( (cl_VehicleLocked(source) == true) and (cl_VehicleOwner(source) ~= player) ) then
			removePedFromVehicle( player )
			return false
		end
		cl_SetVehicleOwner ( source, player )
	end
	return true
end
addEventHandler ( "onVehicleEnter", getRootElement(), cl_PlayerDriveVehicle)

addEventHandler("onElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" then
		cl_RemoveVehicleOwner ( source )
	end
end)

function cl_VehicleRespawn (exploded) 
	cl_RemoveVehicleOwner ( source )
end
addEventHandler ( "OnVehicleRespawn", getRootElement(), cl_VehicleRespawn)

function cl_VehicleExplode ()
	cl_RemoveVehicleOwner ( source )
end
addEventHandler ( "onVehicleExplode", getRootElement(), cl_VehicleExplode)

function cl_SetVehicleOwner ( theVehicle, thePlayer )
	local oldVehicle = getElementData ( thePlayer, "cl_ownedvehicle" )
	if ( oldVehicle ~= false ) then		
		removeElementData ( oldVehicle, "cl_vehicleowner" )
		removeElementData ( oldVehicle, "cl_vehiclelocked" )
		removeElementData ( oldVehicle, "cl_enginestate" )
		setVehicleLocked ( oldVehicle, false ) 
	end
	setElementData ( theVehicle, "cl_vehicleowner", thePlayer )
	setElementData ( theVehicle, "cl_vehiclelocked", false )
	setElementData ( thePlayer, "cl_ownedvehicle", theVehicle )
	setElementData( theVehicle, "cl_enginestate", true )
end

function cl_RemoveVehicleOwner ( theVehicle )
	local theOwner = getElementData ( theVehicle, "cl_vehicleowner" )
	if ( theOwner ~= false ) then
		removeElementData ( theOwner, "cl_ownedvehicle" )
		removeElementData ( theVehicle, "cl_vehicleowner" )
		removeElementData ( theVehicle, "cl_vehiclelocked" )
	end
	setVehicleLocked ( theVehicle, false )
end

function cl_VehicleOwner ( theVehicle )
	return getElementData( theVehicle, "cl_vehicleowner" )

end

function cl_VehicleLocked ( theVehicle )
	return getElementData( theVehicle, "cl_vehiclelocked" )
end

function doToggleLocked ( source )
	local theVehicle , strout
	if ( getElementType(source) == "vehicle" ) then
		theVehicle = source
	end
	if ( getElementType(source) == "player" ) then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end

	if ( theVehicle ) then
		local vehiclename = getVehicleName ( theVehicle )
		if ( getElementData ( theVehicle, "cl_vehiclelocked") == true ) then
			doUnlockVehicle ( source )
		else 
			doLockVehicle ( source )
		end
	end
end	

function doLockVehicle ( source )
	local theVehicle , strout
	if ( getElementType(source) == "vehicle" ) then
		theVehicle = source
	end
	if ( getElementType(source) == "player" ) then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end

	if ( theVehicle ) then
		local vehiclename = getVehicleName ( theVehicle )
		if ( getElementData ( theVehicle, "cl_vehiclelocked") == true ) then
		else 
			setElementData ( theVehicle, "cl_vehiclelocked", true)
			setVehicleLocked ( theVehicle, true ) 
		end
	end
end

function doUnlockVehicle ( source )
	local theVehicle, strout
	if ( getElementType(source) == "vehicle" ) then
		theVehicle = source
	end
	if ( getElementType(source) == "player" ) then
		theVehicle = getElementData ( source, "cl_ownedvehicle" )
	end
	if ( theVehicle ) then
	local vehiclename = getVehicleName ( theVehicle )
		if ( getElementData ( theVehicle, "cl_vehiclelocked") == false ) then
		else
			setElementData ( theVehicle, "cl_vehiclelocked", false)
			setVehicleLocked ( theVehicle, false )
		end
	end
end