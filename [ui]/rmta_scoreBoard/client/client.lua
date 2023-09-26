local screenW, screenH = guiGetScreenSize()
local SB_WIDTH, SB_HEIGHT = 492, 446
local SB_POSX, SB_POSY = screenW/2-SB_WIDTH/2, screenH/2-SB_HEIGHT/2

local HEAD_FONT = exports.rmta_fonts:createFont("RB.ttf", 13)
local COLUMNS_FONT = exports.rmta_fonts:createFont("RB.ttf", 11)
local ITEM_FONT = exports.rmta_fonts:createFont("RR.ttf", 10)

local SB_DATA = getElementData(resourceRoot, "rmta_scoreboard.data")

local playersList = {}
local playersOnlineCount = 0
local playersMaxCount = SB_DATA.MAXPLAYERS
local scrollOffset = 0

-- SETUPS
local itemsCount = 10
local headerColor = tocolor(255, 255, 255, 255) 
local columnsColor = tocolor(80, 80, 80, 255)
local playerLocalColor = tocolor(245, 49, 127, 255)
local playerAunColor = tocolor(80, 80, 80, 125)
local playerColor = tocolor(80, 80, 80, 255)

local columns = {
	{name = "ID", size = 0.09, data = "id"},
	{name = "Ник", size = 0.4, data = "name"},
	{name = "Уровень", size = 0.25, data = "level"},
	{name = "Пинг", size = 0.36},
}

local function drawScoreBoard()
	dxDrawImage(SB_POSX, SB_POSY, SB_WIDTH, SB_HEIGHT, "assets/BG.png")
	dxDrawText("СПИСОК ИГРОКОВ", SB_POSX+15, SB_POSY+15, SB_WIDTH, SB_HEIGHT, headerColor, 1, HEAD_FONT)
	dxDrawText(playersOnlineCount.."/"..playersMaxCount, SB_POSX+15, SB_POSY+15, SB_POSX+SB_WIDTH-15, SB_HEIGHT, headerColor, 1, HEAD_FONT, "right")

	local x = SB_POSX
	for i, column in ipairs(columns) do
		local width = SB_WIDTH * column.size
		dxDrawText(tostring(column.name), x, SB_POSY+75, x+width, SB_POSY+75, columnsColor, 1, COLUMNS_FONT, "center", "center")
		x = x + width
	end
	dxDrawRectangle(SB_POSX+15, SB_POSY+85, SB_WIDTH-37, 1, tocolor(224, 225, 231, 255))


	local y = SB_POSY+70
	for i = scrollOffset + 1, math.min(itemsCount + scrollOffset, #playersList) do
		local item = playersList[i]
		local color = playerColor
		if item.isLocalPlayer then
			color = playerLocalColor
		end
		if item.isLogin then
			color = playerAunColor
		end
		x = SB_POSX
		for j, column in ipairs(columns) do
			local text = item[column.data]
			if text == nil then text = getPlayerPing(item.player) end
			local width = SB_WIDTH * column.size
			dxDrawText(tostring(text), x, y, x+width, y+65, color, 1, ITEM_FONT, "center", "center")
			x = x + width
		end
		y = y + 35
	end

end

local function mouseDown()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset + 1
	if scrollOffset > #playersList - itemsCount then
		scrollOffset = #playersList - itemsCount + 1
	end
end

local function mouseUp()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset - 1
	if scrollOffset < 0 then
		scrollOffset = 0
	end
end

function startScoreBoard()
	addEventHandler("onClientRender", root, drawScoreBoard)

	playersList = {}
	local function addPlayerToList(player, login, isLocalPlayer)
		if type(player) == "table" then
			table.insert(playersList, player)
			return
		end
		table.insert(playersList, {
			isLogin = login,
			isLocalPlayer = isLocalPlayer,
			id = player:getData("player.ID") or "-",
			name = player:getData("player.NICKNAME") or "Авторизовывается",
			level = player:getData("player.LEVEL") or "-",
			player = player 
		})
	end

	local players = getElementsByType("player")
	table.sort(players, function (player1, player2)
		local id1 = player1:getData("splayer.ID") or 999
		local id2 = player2:getData("player.ID") or 999
		return id1 < id2
	end)
	playersOnlineCount = #players

	addPlayerToList(localPlayer, false, true)
	if #players > 0 then
		for i, player in ipairs(players) do
			if player ~= localPlayer then
				addPlayerToList(player, not player:getData("player.NICKNAME"))
			end
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
end

function stopScoreBoard()
	removeEventHandler("onClientRender", root, drawScoreBoard)
	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)
end