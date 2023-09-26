local NAMETAG_MAX_DISTANCE = 15
local NAMETAG_OFFSET = 1.05
local NAMETAG_FONT = "default-bold"

local streamedPlayers = {}


local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, NAMETAG_FONT, "center", "center")
end

addEventHandler("onClientRender", root, function ()
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['nicknames'] then return end

	local cx, cy, cz = getCameraMatrix()
	for player, info in pairs(streamedPlayers) do
		if player:getData("player.LEVEL") then
			local px, py, pz = getElementPosition(player)		
			local x, y = getScreenFromWorldPosition(px, py, pz + NAMETAG_OFFSET)
			if x and y then
				local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
				if distance < NAMETAG_MAX_DISTANCE then
					if player:getData("player.AFK") then -- AFK
						local AFK_TIME = player:getData("player.AFK_TIMER")
						dxDrawNametagText(tostring(AFK_TIME), x, y-16, x, y-16, tocolor(200, 0, 0, 255), 1)
					end
					local text = info.name.."("..info.id..")"
					dxDrawNametagText(text, x, y, x, y, tocolor(255, 255, 255, 255), 1)

				end
			end
		end
	end

end)

local function showPlayer(player)
	if not isElement(player) then
		return false
	end
	setPlayerNametagShowing(player, false)
	if player == localPlayer then
		return
	end
	streamedPlayers[player] = {name = player:getData("player.NICKNAME"), id = player:getData("player.ID")}
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, player in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(player) then 
			showPlayer(player)
		end
		setPlayerNametagShowing(player, false)
	end
end)

addEventHandler("onClientPlayerJoin", root, function()
	if isElementStreamedIn(source) then
		showPlayer(source)
	end
	setPlayerNametagShowing(source, false)
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if getElementType(source) == "player" then
		showPlayer(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if getElementType(source) == "player" then
		streamedPlayers[source] = nil
	end
end)

addEventHandler("onClientPlayerQuit", root, function ()
	streamedPlayers[source] = nil
end)