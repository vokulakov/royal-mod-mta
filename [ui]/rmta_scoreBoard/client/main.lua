local function setScoreBoardVisible()
	if not getElementData(localPlayer, "player.ACTIVE_UI") == 'scoreboard' then return end
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['scoreboard'] then return end

	SB_VISIBLE = not SB_VISIBLE
	showCursor(SB_VISIBLE)
	showChat(not SB_VISIBLE)
	
	if SB_VISIBLE then
		startScoreBoard()
		setElementData(localPlayer, "player.ACTIVE_UI", "scoreboard")
	else
		stopScoreBoard()
		setElementData(localPlayer, "player.ACTIVE_UI", false)
	end

	-- СКРЫТИЕ HUD
	triggerEvent("rmta_showui.setVisiblePlayerUI", getRootElement(), not SB_VISIBLE)
	triggerEvent("rmta_showui.setVisiblePlayerComponentUI", getRootElement(), "scoreboard", true)
end

bindKey("tab", "down", setScoreBoardVisible)
bindKey("tab", "up", setScoreBoardVisible)