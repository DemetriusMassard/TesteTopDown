Menu = {}

function Menu.new()
	local private = {}
	local public = {}
	
	
	print(mapping.down .. "\n" .. mapping.up)
	mouse = {}
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()
	mouse.timer = 0
	
	modes = {}
	modes.modes = love.window.getFullscreenModes()
	modes.txt = {}
	
	for m, res in ipairs(modes.modes) do
		table.insert(modes.txt, res.width .. "x" .. res.height)
	end
	
	private.visible = {}
	
	private.selected = 1
	
	private.main = {}
	table.insert(private.main, Button.new(love.graphics.getWidth()/2-60,200,120,50,"play", {"Play"}))
	table.insert(private.main, Button.new(love.graphics.getWidth()/2-60,255,120,50,"options", {"Options"}))
	table.insert(private.main, Button.new(love.graphics.getWidth()/2-60,310,120,50,"quit", {"Quit"}))
	
	private.options = {}
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,50,190,50,"vsync", {"Enabled", "Disabled"}, "vsync"))
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,105,190,50,"fullscreen", {"Fullscreen", "Windowed"}, "fullscreen"))
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,160,190,50,"resolution", modes.txt, "resolution"))
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,215,190,50,"inputtype", {"Keyboard Mouse", "Keyboard", "Joystick"}, "Controller Type"))
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,270,190,50,"save", {"save"}))
	table.insert(private.options, Button.new(love.graphics.getWidth()/2-95,325,190,50,"back", {"back"}))
	
	private.visible = private.main
	private.visible[private.selected].focus()
	
	function public.update(dt)
		print(joystick:getGamepadAxis("leftx"))
		print(joystick:getGamepadAxis("lefty"))
		os.execute("cls")
		if settings.inputtype == "keyboardmouse" then
			mouse.x, mouse.y = love.mouse.getPosition()
			mouse.timer = mouse.timer + dt
			
			for b,button in pairs(private.visible) do
				button.unfocus()
				if coll(button.x,button.y,button.w,button.h, mouse.x, mouse.y, 1,1) then
					private.selected = b
				end
			end
			private.visible[private.selected].focus()
			accept = split(mapping.accept)
			if mouse.timer >0.4 then
				if accept[1] == 'mouse' then
					if love.mouse.isDown(accept[2]) then
						private.accept()
						mouse.timer = 0
					end
				end
			end
		end
	end
	
	function public.keypressed(key,unicode)
		if key == mapping.down then
			private.selected = private.selected+1
			if private.selected == table.getn(private.visible)+1 then
				private.selected = 1
			end
		end
		if key == mapping.up then
			private.selected = private.selected-1
			if private.selected ==0 then
				private.selected = table.getn(private.visible)
			end
		end
		
		if key == mapping.left then
			private.visible[private.selected].changeOption(1)
		end
		if key == mapping.right then
			private.visible[private.selected].changeOption(-1)
		end
		
		if key == mapping.accept then
			private.accept()
		end
		
		for b,button in pairs(private.visible) do
			button.unfocus()
			
		end
		private.visible[private.selected].focus()
	end
	
	function private.accept()
		if private.visible == private.main then
			if private.selected == 1 then
				Level = Level1.new()
			elseif private.selected == 2 then
				private.visible = private.options
				private.selected = 1
			elseif private.selected == 3 then
				love.event.quit()
			end
		end
		if private.visible == private.options then
			if private.selected == 5 then
				selectedmode = modes.modes[private.visible[3].getOption()]
				if private.visible[1].getOption() == 1 then
					settings.vsync = true
				else
					settings.vsync = false
				end
				if private.visible[2].getOption() == 1 then
					settings.fullscreen = true
				else
					settings.fullscreen = false
				end
				settings.resolution.w = selectedmode.width
				settings.resolution.h = selectedmode.height
				if private.visible[4].getOption() == 1 then
					settings.inputtype = "keyboardmouse"
				elseif private.visible[4].getOption() == 2 then
					settings.inputtype = "keyboard"
				else
					settings.inputtype = "joystick"
				end
				
				applySettings()
				Level = Menu.new()
				mapping = settings[settings.inputtype]
				print(selectedmode.width .. 'x' .. selectedmode.height)
			elseif private.selected == 6 then
				private.selected = 1
				private.visible = private.main
			end
		end
	end
	
	function public.draw()
		for o, obj in pairs(private.visible) do
			obj.draw()
		end
	end
	
	return public
end