addEventHandler("onResourceStart", resourceRoot, function()
	local DATA = {}
	DATA.MAXPLAYERS = getMaxPlayers() -- максимальное количество игроков
	setElementData(resourceRoot, "rmta_scoreboard.data", DATA)
end)


