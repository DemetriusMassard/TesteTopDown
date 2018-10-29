function love.load()

	requireAll('content/objects')
	requireAll('content/entities')
	requireAll('levels')
	
	bump = require('bump')
	json = require('json')
	
	loadSettings()
	Level = Menu.new()
    joystick_list = love.joystick.getJoysticks()
	for j, joy in pairs(joystick_list) do
		print(joy)
	end
	love.joystick.loadGamepadMappings('mappings')
    for j,joystick in pairs(joystick_list) do
		if joystick:isGamepad() then
			print("new gamepad '"..joystick:getName().."' with GUID "..joystick:getGUID())
		else
			print("new joystick '"..joystick:getName().."' with GUID "..joystick:getGUID())
		end
	end
end

function love.update(dt)
	Level.update(dt)
end

function love.draw()
	Level.draw()
end

function love.keypressed(key, unicode)
	Level.keypressed(key, unicode, nil, nil)
end

function love.gamepadpressed(joystick, button)
	Level.keypressed(nil, nil, joystick, button)
	print(button)
end


--GlobalFunctions

function requireAll(dir)
	local files = love.filesystem.getDirectoryItems(dir)
	for i, e in pairs(files) do
	
		trim = string.gsub( e, ".lua", "")
		require(dir .. "/" .. trim)
	end

end
function loadSettings()
	settingsexists = love.filesystem.getInfo('settings.ini', 'file')
	if not settingsexists then
		settings = {
			resolution = {
				w = 800,
				h = 600
			},
			fullscreen = false,
			fullscreentype = "exclusive",
			msaa = 0,
			vsync = false,
			inputtype = "keyboard",
			keyboard = {
				accept = "z",
				decline = "x",
				up = "up",
				down = "down",
				left = "left",
				up = "up"
			}
		}
		print("ay")
		saveSettings()
	else
		settings = json.decode(love.filesystem.read('settings.ini'))
		
	end
	applySettings()
	print(json.encode(settings))
end

function saveSettings()
	settingsFile = love.filesystem.newFile('settings.ini')
	settingsFile:open("w")
	settingsFile:write(json.encode(settings))
	settingsFile:close()
end

function applySettings()
	love.window.setMode(settings.resolution.w,settings.resolution.h, {fullscreen = settings.fullscreen,fullscreentype= settings.fullscreentype, vsync = settings.vsync,msaa = settings.msaa })
	saveSettings()
end

function split(text, delim)
    -- returns an array of fields based on text and delimiter (one character only)
    local result = {}
    local magic = "().%+-*?[]^$"

    if delim == nil then
        delim = "%s"
    elseif string.find(delim, magic, 1, true) then
        -- escape magic
        delim = "%"..delim
    end

    local pattern = "[^"..delim.."]+"
    for w in string.gmatch(text, pattern) do
        table.insert(result, w)
    end
    return result
end