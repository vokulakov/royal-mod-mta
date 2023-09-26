local PLAYERS_IDS = {}

addEventHandler("onResourceStart", resourceRoot, function()
	players = getElementsByType("player")
	for i, player in ipairs(players) do
		PLAYERS_IDS[i] = player
		setElementData(player, "player.ID", tonumber(i))
	end
end)

addEventHandler("onPlayerJoin", root, function()
	if #PLAYERS_IDS == 0 then
		PLAYERS_IDS[1] = source
		setElementData(source, "player.ID", 1)
		return
	end
	for i = 1, #PLAYERS_IDS + 1 do
		if not isElement(PLAYERS_IDS[i]) then
			PLAYERS_IDS[i] = source
			setElementData(source, "player.ID", tonumber(i))
			return
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local id = tonumber(getElementData(source, "player.ID"))
	if id then
		PLAYERS_IDS[id] = nil
		removeElementData(source, "player.ID")
	end
end)

local function getPlayerFromID(id) -- определение элемента игрока по ID
	local player = PLAYERS_IDS[id]
	if player ~= nil then 
		return player
	end

	return false
end

