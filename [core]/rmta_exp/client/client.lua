local function newLevel() 
	exports["rmta_sounds"]:playSound("sound_mission.mp3")
end
addEvent("rmta_exp.newLevel", true)
addEventHandler("rmta_exp.newLevel", root, newLevel)