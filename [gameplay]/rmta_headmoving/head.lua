local width, height = guiGetScreenSize ()

addEventHandler("onClientRender", getRootElement(), function()
	for k, player in ipairs(getElementsByType("player")) do
		if getElementHealth(player) >= 1 then
			local lx, ly, lz = getWorldFromScreenPosition(width/2, height/2, 10)
			setPedLookAt(player, lx, ly, lz)
		end 
	end
end)