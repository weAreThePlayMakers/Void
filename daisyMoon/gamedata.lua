
gamedata = {}

local gamedataPath = "gamedata/"
local database = {}

function gamedata.load(dataName, fileName)
	if not database[dataName] then
		database[dataName] = video.createSpriteState(dataName, gamedataPath ..fileName)
		return dataName
	else
		print("Gamedata: The gamedata entry with the name of '" ..dataName .."' already exists and so has not been loaded again.")
	end
end

function gamedata.loadSet(dataSet)
	for i, data in pairs(dataSet) do
		if not database[data] then
			database[data] = video.createSpriteState(data, gamedataPath ..fileName)
		else
			print("Gamedata: The gamedata entry with the name of '" ..data .."' already exists and so has not been loaded again.")
		end
	end
end

function gamedata.unload(dataName)
	if database[dataName] then
		database[dataName] = nil
	else
		print("Gamedata: The gamedata entry with the name of '" ..dataName .."' was not found and might already be unloaded.")
	end
end

function gamedata.unloadSet(dataSet)
	for i, data in pairs(dataSet) do
		if database[data] then
			database[data] = nil
		else
			print("Gamedata: The gamedata entry with the name of '" ..data .."' was not found and might already be unloaded.")
		end
	end
end

function gamedata.unloadAll()
	database = {}
end

function gamedata.reload(dataName, fileName)
	if database[dataName] then
		database[dataName] = video.createSpriteState(dataName, gamedataPath ..fileName)
	else
		print("Gamedata: The gamedata entry with the name of '" ..dataName .."' does not exist and could so not be reloaded.")
	end
end

function gamedata.get(name)
	if(database[name] ~= nil) then
		return database[name]
	else
		print("Gamedata: The gamedata entry with the name of '" ..name .."' was not found. Make sure it has been loaded before accessing it.")
	end
end