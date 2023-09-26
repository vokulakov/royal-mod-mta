local function chekExperiencePlayer(player) -- проверка на опыт
	local LEVEL = getElementData(player, "player.LEVEL")
	local EXP = getElementData(player, "player.EXP")
	local MAX_EXP = getExperienceForLevel(LEVEL)
	if EXP >= MAX_EXP then
		setElementData(player, "player.EXP", 0)
		setElementData(player, "player.LEVEL", LEVEL + 1)
		triggerClientEvent(player, "rmta_exp.newLevel", player)
	end
end

local function givePlayerExperience(player, current_level) -- выдача опыта
	local LEVEL = getElementData(player, "player.LEVEL")
	local XP = getGivePlayerExperience(current_level, LEVEL)
	setElementData(player, "player.EXP", getElementData(player, "player.EXP") + XP)
	chekExperiencePlayer(player)
end
addEvent("rmta_exp.givePlayerExperience", true)
addEventHandler("rmta_exp.givePlayerExperience", root, givePlayerExperience)
