function love.load()

	requireAll('content/objects')
	requireAll('content/entities')
	requireAll('levels')
	
	bump = require('bump')
	json = require('json')
	
	cursor = love.mouse.newCursor( 'assets/crosshair.png', 8, 8 )
	love.mouse.setCursor(cursor)
	
	images = {}
	loadImages('assets')
	
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
	if settings.inputtype == "keyboard" then
		Level.keypressed(key, unicode, nil, nil)
	end
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

function loadImages(dir)
	local files = love.filesystem.getDirectoryItems(dir)
	for i, image in pairs(files) do
		images[image] = love.graphics.newImage(dir .. "/" .. image)
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
				accept = "mouse 1",
				decline = "esc",
				interact = "e",
				up = "w",
				down = "s",
				left = "a",
				right = "s"
			}
		}
		saveSettings()
	else
		settings = json.decode(love.filesystem.read('settings.ini'))
		
	end
	applySettings()
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

function coll(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2+w2 and
			x2 < x1+w1 and
			y1 < y2+h2 and
			y2 < y1+h1
end