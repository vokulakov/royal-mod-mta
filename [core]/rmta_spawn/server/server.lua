local spawnPosition = {
	{x = 1770, y = -1897, z = 13}, -- ЖД
	{x = 1109, y = -1797, z = 16} -- Автовокзал
}

local function playerSpawn(player)
 	local num = math.random(1, #spawnPosition)
	local x, y, z = spawnPosition[num].x, spawnPosition[num].y, spawnPosition[num].z
	spawnPlayer(player, x, y, z, 90, 78, 0, 0)
	fadeCamera(player, true, 5)
	setCameraTarget(player, player)
end
addEvent("rmta_spawn.spawnPlayer", true)
addEventHandler("rmta_spawn.spawnPlayer", root, playerSpawn)
