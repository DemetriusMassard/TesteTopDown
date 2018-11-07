function love.load()

	requireAll('content/objects')
	requireAll('content/entities')
	requireAll('levels')
	requireAll('content/weapons')
	
	bump = require('bump')
	json = require('json')
	
	cursor = love.mouse.newCursor( 'assets/crosshair.png', 8, 8 )
	
	images = {}
	loadImages('assets')
	
	loadSettings()
	mapping = settings[settings.inputtype]
	
	Level = Menu.new()
	love.joystick.loadGamepadMappings('mappings')
    joystick_list = love.joystick.getJoysticks()
	for j, joy in pairs(joystick_list) do
		print(joy)
		if joy:isGamepad() then
			print("new gamepad '"..joy:getName().."' with GUID "..joy:getGUID())
		else
			print("new joystick '"..joy:getName().."' with GUID "..joy:getGUID())
		end
	end
	joystick = joystick_list[1]
end

function love.update(dt)
	Level.update(dt)
end

function love.draw()
	Level.draw()
end

function love.keypressed(key, unicode)
	if settings.inputtype == "keyboard" or settings.inputtype == "keyboardmouse" then
		Level.keypressed(key, unicode)
	end
end

function love.gamepadpressed(joystick, button)
	Level.keypressed(button,joystick)
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
			inputtype = "keyboardmouse",
			keyboardmouse = {
				primary = "1",
				secondary = "2",
				tertiary = "3",
				weaponup = "",
				weapondown = "",
				reload = "r",
				accept = "mouse 1",
				decline = "esc",
				interact = "e",
				up = "w",
				down = "s",
				left = "a",
				right = "d"
			},
			keyboard = {
				primary = "a",
				secondary = "s",
				tertiary = "d",
				weaponup = "",
				weapondown = "",
				reload = "x",
				accept = "z",
				decline = "esc",
				interact = "c",
				up = "up",
				down = "down",
				left = "left",
				right = "right"
			},
			joystick = {
				primary = "",
				secondary = "",
				tertiary = "",
				weaponup = "leftshoulder",
				weapondown = "",
				reload = "y",
				accept = "rightshoulder",
				decline = "b",
				interact = "a",
				up = "dpup",
				down = "dpdown",
				left = "dpleft",
				right = "dpright"
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
	if settings.inputtype == "keyboardmouse" then
		love.mouse.setCursor(cursor)
	else
		love.mouse.setVisible(false)
	end
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