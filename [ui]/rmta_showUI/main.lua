local UI = {
	['all'] = true, -- весь HUD
	['radar'] = true, -- радар
	['hud'] = true, -- статистика игрока
	['speed'] = true, -- спидометр
	['map'] = true, -- карта
	['scoreboard'] = true, -- список игроков
	['nicknames'] = true -- ники игроков
}

local function setVisiblePlayerUI(state)
	for component in pairs(UI) do 
		UI[component] = state 
	end
	setElementData(localPlayer, "player.UI", UI)
end
addEvent("rmta_showui.setVisiblePlayerUI", true)
addEventHandler("rmta_showui.setVisiblePlayerUI", getRootElement(), setVisiblePlayerUI)

local function setVisiblePlayerComponentUI(theComponent, state)
	for component in pairs(UI) do 
		if component == theComponent then
			UI[component] = state 
		end
		setElementData(localPlayer, "player.UI", UI)
	end
end
addEvent("rmta_showui.setVisiblePlayerComponentUI", true)
addEventHandler("rmta_showui.setVisiblePlayerComponentUI", getRootElement(), setVisiblePlayerComponentUI)

addEventHandler("onClientResourceStart", resourceRoot, function()
	setVisiblePlayerUI(false)
	setElementData(localPlayer, "player.ACTIVE_UI", false) -- Active
end)