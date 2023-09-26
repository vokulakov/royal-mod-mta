function createShader(name, ... )
	local element = dxCreateShader("shaders/"..name, ...)
	if not element then 
		return false
	end
	return element
end