local sX, sY = guiGetScreenSize()

local screenWidth, screenHeight = sX, sY - 20 -- положение спидометра

local smothedRotation = 0

local maskShader
local tShader
local circleTexturesSpeed = {}
local circleTexturesTaxometr = {}

local SPEEDO_FONT = exports["rmta_fonts"]:createFont("SPEED_0.ttf", 17)
local RPM_FONT = exports["rmta_fonts"]:createFont("SPEED_0.ttf", 15)
local REG = exports["rmta_fonts"]:createFont("RR.ttf", 8)
local REG_CRUISE = exports["rmta_fonts"]:createFont("RR.ttf", 7)

addEventHandler( "onClientResourceStart", resourceRoot, function()

	maskShader = exports["rmta_shaders"]:createShader("mask3d.fx")
	local maskTexture = dxCreateTexture("assets/s_mask.png")
	dxSetShaderValue(maskShader, "sMaskTexture", maskTexture) 
	dxSetShaderValue(maskShader, "gUVRotCenter", 0.5, 0.5)
	for i = 1, 3 do
		circleTexturesSpeed[i] = dxCreateTexture("assets/s_circle"..tostring(i)..".png")
	end
	
	tShader = exports["rmta_shaders"]:createShader("mask3d.fx")
	local tTexture = dxCreateTexture("assets/t_mask.png")
	dxSetShaderValue(tShader, "sMaskTexture", tTexture) 
	dxSetShaderValue(tShader, "gUVRotCenter", 0.5, 0.5)

	for i = 1, 2 do
		circleTexturesTaxometr[i] = dxCreateTexture("assets/t_circle"..tostring(i)..".png")
	end
	
end)

local function drawSpeedometr()
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['speed'] then return end
	local veh = getPedOccupiedVehicle(localPlayer) 
    if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end

	local vehicleSpeed = getVehicleSpeed()
	local rot = math.floor(((175/12800)* getVehicleRPM(getPedOccupiedVehicle(getLocalPlayer()))) + 0.5)
	if (smothedRotation < rot) then smothedRotation = smothedRotation + 2.5 end
	if (smothedRotation > rot) then smothedRotation = smothedRotation - 2.5 end
	
	dxDrawImage(screenWidth-200, screenHeight-200, 162, 162, "assets/s_speedo.png")

	dxDrawImage(screenWidth-300, screenHeight-155, 122, 122, "assets/s_tahometer.png")
	
	if vehicleSpeed < 243 then
		dxDrawImage(screenWidth-200, screenHeight-200, 160, 160, "assets/needle_s.png", vehicleSpeed - 3, 0.0, 0.0, tocolor(255,255,255,255), false)
	else
		dxDrawImage(screenWidth-200, screenHeight-200, 160, 160, "assets/needle_s.png", 240, 0.0, 0.0, tocolor(255,255,255,255), false)
	end
	
	dxDrawImage(screenWidth-295, screenHeight-150, 115, 115, "assets/needle_t.png", smothedRotation - 5, 0.0, 0.0, tocolor(255,255,255,255), false)
	
	if vehicleSpeed < 90 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[1])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 0.2)
	elseif vehicleSpeed > 90 and vehicleSpeed < 170 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[2])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 4.9)
	elseif vehicleSpeed > 170 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[3])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 3.3)
	end
		
	dxDrawImage(screenWidth-200, screenHeight-200, 162, 162, maskShader, 0, 0, 0, tocolor(255,168,0,125))
	
	if (0 - (smothedRotation/57)) > - 1 then
		dxSetShaderValue(tShader, "sPicTexture", circleTexturesSpeed[1])
		dxSetShaderValue(tShader, "gUVRotAngle", 0 - (smothedRotation/57) + 0.35)
	elseif (0 - (smothedRotation/57)) > - 4.4 then
		dxSetShaderValue(tShader, "sPicTexture", circleTexturesSpeed[2])
		dxSetShaderValue(tShader, "gUVRotAngle", 0 - (smothedRotation/57) - 4.5)
	end
	
	dxDrawImage(screenWidth-300, screenHeight-155, 122, 122, tShader, 0, 0, 0, tocolor(255,255,255,125))
	
	dxDrawSpeedText( getElementSpeed(veh), screenWidth, screenHeight-105, screenWidth-240, 300, tocolor ( 255,255,255 ), 1, SPEEDO_FONT, "center")
	dxDrawSpeedText( "км/ч", screenWidth-133, screenHeight-82, 240, 300, tocolor ( 255,255,255 ), 1, REG)

	dxDrawSpeedText(string.sub(getVehicleRPM(veh), 1, 1), screenWidth, screenHeight-80, screenWidth-430, 300, tocolor ( 255,255,255 ), 1, RPM_FONT, "center")
	dxDrawSpeedText( "RPM", screenWidth-226, screenHeight-53, 240, 300, tocolor ( 255,255,255 ), 1, REG)

	if not (getVehicleEngineState(veh)) then
		dxDrawImage(screenWidth-185, screenHeight-45, 26, 26, "assets/engine_off.png")
	else
		dxDrawImage(screenWidth-185, screenHeight-45, 26, 26, "assets/engine_on.png")
	end
	
	if not isVehicleLocked ( veh ) then  
		dxDrawImage(screenWidth-125, screenHeight-45, 26, 26, "assets/door_open.png")
	else
		dxDrawImage(screenWidth-125, screenHeight-45, 26, 26, "assets/door_close.png")
	end
	
	if (getVehicleOverrideLights(veh) == 2) then
		dxDrawImage(screenWidth-95, screenHeight-45, 26, 26, "assets/lights_on.png")
	else
		dxDrawImage(screenWidth-95, screenHeight-45, 26, 26, "assets/lights_off.png")
	end

	if getElementData(veh, "cruiseSpeedEnabled") then 
		dxDrawImage(screenWidth-155, screenHeight-45, 26, 26, "assets/cc_on.png")
		dxDrawSpeedText(getElementSpeed(veh), screenWidth, screenHeight-23, screenWidth-284, 300, tocolor ( 255,255,255 ), 1, REG_CRUISE, "center")
	else
		dxDrawImage(screenWidth-155, screenHeight-45, 26, 26, "assets/cc_off.png")
	end

	dxDrawImage(screenWidth-160, screenHeight-87, 26, 26, "assets/turnlight_l.png")
	dxDrawImage(screenWidth-107, screenHeight-87, 26, 26, "assets/turnlight_r.png")
	
	dxDrawImage(screenWidth-55, screenHeight-190, 35, 125, "assets/s_fuel.png")
	dxDrawImage(screenWidth-35, screenHeight-60, 26, 26, "assets/fuel.png")
	
end

addEventHandler("onClientVehicleEnter", root, function (thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		addEventHandler("onClientRender", root, drawSpeedometr)
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then
        removeEventHandler("onClientRender", root, drawSpeedometr)
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
		removeEventHandler("onClientRender", root, drawSpeedometr)
	end
end)

addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), function()
	if not getPedOccupiedVehicle(source) then return end
	removeEventHandler("onClientRender", root, drawSpeedometr)
end)

function dxDrawSpeedText(text, x1, y1, x2, y2, color, size, font, pos)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), size, font, pos or nil)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), size, font, pos or nil)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), size, font, pos or nil)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), size, font, pos or nil)
	dxDrawText(text, x1, y1, x2, y2, color, size, font, pos or nil)
end

function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 165
    end
    return 0
end

function getElementSpeed(element)
	speedx, speedy, speedz = getElementVelocity (element)
	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	kmh = actualspeed * 1.61 * 100
	return math.round(kmh)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getVehicleRPM(vehicle)
	local vehicleRPM = 0
    if (vehicle) then  
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then   
				vehicleRPM = math.floor(((getElementSpeed(vehicle, "kmh")/getVehicleCurrentGear(vehicle))*180) + 0.5) 
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh")*80) + 0.5)
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            end
        else
            vehicleRPM = 0
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end