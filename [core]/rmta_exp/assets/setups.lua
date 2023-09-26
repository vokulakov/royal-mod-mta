MAX_LEVEL = 50 -- максимальное количество уровней
START_EXP = 200 -- начальное колиечство опыта

function getExperienceForLevel(level) -- количества опыта для уровня
	local EXP = ((START_EXP + (START_EXP + 100 *(level-1)))/2)*level
	return math.ceil(EXP)
end

function getGivePlayerExperience(current_level, player_level) -- количества выдачи опыта
	local XP = getExperienceForLevel(player_level)/100*(MAX_LEVEL+current_level-player_level)/(MAX_LEVEL+player_level)
	return math.ceil(XP)
end

