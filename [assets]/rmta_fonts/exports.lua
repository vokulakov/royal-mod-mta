function createFont(name, ...)
	local element = dxCreateFont("fonts/"..tostring(name), ...)
	return element	
end

function createFontGui(name, ...)
	local element = guiCreateFont("fonts/"..tostring(name), ...)
	return element
end
