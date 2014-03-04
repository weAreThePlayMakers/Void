
--Note: Gamedata currently only contains images

gamedata = {}

local database = {}

function gamedata.insert(dataName, data)
	if not database[dataName] then
		database[dataName] = data
	else
		print("Gamedata: The gamedata entry with the name of '" ..dataName .."' already exists.")
	end
end

function gamedata.remove(dataName)
	if database[dataName] then
		database[dataName] = nil
	else
		print("Gamedata: The gamedata entry with the name of '" ..dataName .."' was not found or might already be unloaded.")
	end
end

function gamedata.unloadAll()
	database = {}
end

function gamedata.get(name)
	if(database[name] ~= nil) then

		return database[name]
	else
		print("Gamedata: The gamedata entry with the name of '" ..name .."' was not found. Make sure it has been loaded before accessing it.")
	end
end