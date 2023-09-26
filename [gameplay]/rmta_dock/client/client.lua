local STREAMED_TEXT = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, function()
	local cx, cy, cz = getCameraMatrix()
	for element, info in pairs(STREAMED_TEXT) do
		local ex, ey, ez = getElementPosition(element)		
		local x, y = getScreenFromWorldPosition(ex, ey, ez + info.text_offset)
		if x and y then
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, ex, ey, ez)
			if distance < info.dis then
				dxDrawCustomText(info.text, x, y, x, y, tocolor(info.color[1], info.color[2], info.color[3], info.color[4]), 1)
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "pickup" then
		local data = getElementData(source, "pickup:data")
		if not data then return end
		STREAMED_TEXT[source] = data
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" then
		if not getElementData(source, "pickup:data") then return end
		STREAMED_TEXT[source] = nil
	end
end)