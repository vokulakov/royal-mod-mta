local models = { 
	{id = 411, file = "assets/car1"}, -- ламба
	{id = 445, file = "assets/car2"}, 
	{id = 530, file = "assets/forklift/forklift"}, -- погрузчик
}

addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	for _, car in pairs(models) do
		txd = engineLoadTXD(car.file..'.txd', car.id)
		engineImportTXD(txd, car.id)
		dff = engineLoadDFF(car.file..'.dff', car.id)
		engineReplaceModel(dff, car.id)
	end
end)
