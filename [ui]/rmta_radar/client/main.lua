local screenWidth, screenHeight = guiGetScreenSize()
local radarRenderTarget = dxCreateRenderTarget(180, 180) 

local worldW, worldH = 3072, 3072

addEventHandler("onClientResourceStart", resourceRoot, function()
	radarMaskShader = exports["rmta_shaders"]:createShader("mask3d.fx")
	FONT = exports["rmta_fonts"]:createFont("SPEED_0.ttf", 14, false, "draft")
	local radarMaskTexture = dxCreateTexture("assets/radar_mask.png")
	dxSetShaderValue(radarMaskShader, "sMaskTexture", radarMaskTexture) 
	dxSetShaderValue(radarMaskShader, "gUVRotCenter", 0, 0)
	dxSetShaderValue(radarMaskShader, "gUVRotAngle", 0)
end)

local function getCameraRotationZ()
    local camx, camy, camz, camlx, camly, camlz = getCameraMatrix()
    local t = -math.deg(math.atan2(camlx - camx,camly - camy))
    if t < 0 then t = t + 360 end;
    return t;
end

local function getMapFromWorldPosition(worldX, worldY)
	local mX = mapX+worldW/6000*(worldX-(-3000))
	local mY = mapY+worldH/6000*(3000-worldY)
	return mX, mY
end

local function dxDrawCustomText(text, x1, y1, x2, y2, color, size, font)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), size, font)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), size, font)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), size, font)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), size, font)
	dxDrawText(text, x1, y1, x2, y2, color, size, font)
end

local function showRadar()
	local posxP, posyP, poszP = getElementPosition(localPlayer)
	local rotxP, rotyP, rotzP = getElementRotation(localPlayer)
	local mW, mH = dxGetMaterialSize(radarRenderTarget)
	local X, Y = mW/2 -(posxP/(6000/worldW)), mH/2 +(posyP/(6000/worldH))
	local camRotZ = getCameraRotationZ()
	
	X, Y = X, Y-40
	mapX, mapY = (X - worldW/2), (mH/5 + (Y - worldH/2))
	
	dxSetRenderTarget(radarRenderTarget, true) 
		dxDrawImage(0, 0, worldW, worldH, "assets/water.jpg")
		dxDrawImage(mapX, mapY, worldW, worldH, "assets/radar_map.jpg")

		-- Положение игроков
		for _, player in ipairs(getElementsByType("player")) do
			if player ~= localPlayer then 
				local px, py = getElementPosition(player)
				local pX, pY = getMapFromWorldPosition(px, py)
				dxDrawImage(pX-10, pY-10, 15, 15, "assets/blip/0.png", camRotZ, 0, 0, tocolor(255, 255, 255, 255))
			end
		end

		local pX, pY = getMapFromWorldPosition(posxP, posyP)
		dxDrawImage(pX-10, pY-10, 20, 20, "assets/blip/2.png", (-rotzP)%360,  0,  0,  tocolor(255, 255, 255, 255))
	dxSetRenderTarget()   
	dxSetShaderValue(radarMaskShader, "sPicTexture", radarRenderTarget)

	dxDrawImage(30, screenHeight-200, 180, 180, radarMaskShader, camRotZ)
	dxDrawImage(30, screenHeight-200, 180, 180, 'assets/radar_cover.png', camRotZ, 0, 0, tocolor(255, 255, 255, 255), false)

	-- Название ТС
	local veh = getPedOccupiedVehicle(localPlayer) 
    if veh and getVehicleOccupant(veh) == localPlayer then 
		local vehicleName = getVehicleName(veh)
		dxDrawImage(200, screenHeight-90, 26, 26, "assets/icon_car.png")
		dxDrawCustomText(vehicleName, 227, screenHeight-88, screenWidth, screenHeight, tocolor ( 254, 254, 254, 255 ), 1, FONT) 
	end

	-- Местоположение
	dxDrawImage(200, screenHeight-60, 26, 26, "assets/icon_gps.png")
	local location = getZoneName(posxP, posyP, poszP)
	local city = getZoneName(posxP, posyP, poszP, true)
	dxDrawCustomText(location..", "..city, 227, screenHeight-58, screenWidth, screenHeight, tocolor ( 254, 254, 254, 255 ), 1, FONT) 
end

addEventHandler("onClientRender", getRootElement(), function()
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['radar'] then return end
	showRadar()
end)
