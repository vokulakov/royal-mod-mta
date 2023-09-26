local screenWidth, screenHeight = guiGetScreenSize()
local posX, posY = 10, 10

local TIMEFONT = exports["rmta_fonts"]:createFont("RB.ttf", 11, false, "draft")
local MONEYFONT = exports["rmta_fonts"]:createFont("RB.ttf", 13, false, "draft")
local COINSFONT = exports["rmta_fonts"]:createFont("RB.ttf", 8, false, "draft")
local EXPFONT = exports["rmta_fonts"]:createFont("RB.ttf", 7, false, "draft")

local function showHUD()
	local LEVEL = getElementData(localPlayer, "player.LEVEL")
	if not LEVEL then return end
	dxDrawImage((screenWidth-258)-posX, posY, 258, 60, "assets/bg.png")

	-- EXP
	dxDrawImage((screenWidth-20)-130-posX, posY+5, 20, 20, "assets/hud_l.png")
	dxDrawImage((screenWidth-258)+5-posX, posY+4, 102, 22, "assets/hud_low.png")
	local MAX_EXP = exports["rmta_exp"]:getExperienceForLevel(LEVEL)
	local EXP = getElementData(localPlayer, "player.EXP")
	local EXP_BAR = 102/MAX_EXP*EXP
	dxDrawImageSection((screenWidth-258)+5-posX, posY+4, EXP_BAR, 22, 0, 0, EXP_BAR, 22, "assets/hud_level.png")
	dxDrawText(EXP.."/"..MAX_EXP, (screenWidth-258)+10-posX, posY+8, (screenWidth-258)+102-posX, posY+8, tocolor ( 255, 255, 255, 255 ), 1, EXPFONT, "center") 
	-- HP
	dxDrawImage((screenWidth-20)-5-posX, posY+5, 20, 20, "assets/hud_h.png")
	dxDrawImage((screenWidth-102)-25-posX, posY+4, 102, 22, "assets/hud_low.png")
	local HP_BAR = 102/100*getElementHealth(localPlayer)
	dxDrawImageSection((screenWidth-102)-25-posX, posY+4, HP_BAR, 22, 0, 0, HP_BAR, 22, "assets/hud_heal.png")

	-- Money
	dxDrawImage((screenWidth-26)-5-posX, posY+28, 26, 26, "assets/hud_m.png")
	dxDrawText (string.format("%08d", getPlayerMoney()), (screenWidth-26)-95-posX, posY+24, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, MONEYFONT) 
	
	-- Coins
	dxDrawText (getElementData(localPlayer, "player.COIN"), (screenWidth-26)-9-posX, posY+40, (screenWidth-26)-9-posX, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, COINSFONT, "right") 
	
	-- Clock
	dxDrawImage((screenWidth-258)+5-posX, posY+34, 19, 19, "assets/hud_c.png")
	dxDrawText (string.format("%02d:%02d", getTime()), (screenWidth-258)+30-posX, posY+34, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, TIMEFONT) 
	
	-- Message
	dxDrawImage((screenWidth-22)-152-posX, posY+35, 22, 16, "assets/hud_msg.png")
end

addEventHandler("onClientRender", getRootElement(), function()
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['hud'] then return end
	showHUD()
end)

