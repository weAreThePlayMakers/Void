
ambience = {}

local sounds = {}
local path = "ambience/"
local current = ""

function ambience.play(filename, volume)
	if sounds[filename] then

		sound = sounds[filename]

		if not sound.playing then
			sound.volume = volume
			sound.playing = true

			audio.playMusic(sound.filename, sound.volume * settings.audio.gameVolume, true)
		elseif sound.volume ~= volume then
			ambience.changeVolume(filename, volume)
		end
	end
end

function ambience.halt(filename)
	sounds[filename].playing = false

	audio.stopMusic(sounds[filename].filename)
end

function ambience.stopall()
	for i, sound in pairs(sounds) do
		audio.stopMusic(sound.filename)
	end
end

function ambience.add(filename)
	sound = {}

	sound.filename = path ..filename
	sound.volume = 1
	sound.playing = false

	sounds[filename] = sound
end

function ambience.getCurrent()
	return current.filename
end

function ambience.changeVolume(filename, volume)
	if sounds[filename] then
		sounds[filename].volume = volume
		audio.updateMusic(sounds[filename].filename, volume)
	end
end

function ambience.updateVolume()
	for i, sound in pairs(sounds) do
		audio.updateMusic(sound.filename, sound.volume * settings.audio.gameVolume)
	end
end

local function load()
	ambience.add("background.ogg")
	ambience.add("background_zone.ogg")
end
hook.add("gameInit", load())