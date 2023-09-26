local function setWorldTime()
	local TIME_HOUR, TIME_MINUTE = getTime()
	setTime(TIME_HOUR, TIME_MINUTE)
    setMinuteDuration(10000)
end
addEvent("rmta_world.setWorldTime", true)
addEventHandler("rmta_world.setWorldTime", getRootElement(), setWorldTime)
