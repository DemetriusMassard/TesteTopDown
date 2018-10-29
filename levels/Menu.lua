Menu = {}

function Menu.new()
	local private = {}
	local public = {}
	
	modes = {}
	modes.modes = love.window.getFullscreenModes()
	modes.txt = {}
	
	for m, res in ipairs(modes.modes) do
		table.insert(modes.txt, res.width .. "x" .. res.height)
	end
	
	private.visible = {}
	
	private.selected = 1
	
	private.main = {}
	table.insert(private.main, Button.new(120,20,120,50,"play", {"play"}))
	table.insert(private.main, Button.new(120,150,120,50,"options", {"Options"}))
	
	private.options = {}
	table.insert(private.options, Button.new(120,20,250,100,"opt1", {"aasda"}))
	table.insert(private.options, Button.new(120,150,250,100,"opt2", {"asd"}))
	table.insert(private.options, Button.new(120,280,250,100,"save", modes.txt))
	
	
	private.visible = private.main
	
	function public.update(dt)
		
		for b,button in pairs(private.visible) do
			button.unfocus()
		end
		private.visible[private.selected].focus()
		
	end
	
	function public.keypressed(key,unicode)
		if key == "down" then
			private.selected = private.selected+1
			if private.selected == table.getn(private.visible)+1 then
				private.selected = 1
			end
		end
		if key == "up" then
			private.selected = private.selected-1
			if private.selected ==0 then
				private.selected = table.getn(private.visible)
			end
		end
		
		if key == "left" then
			private.visible[private.selected].changeOption(1)
		end
		if key == "right" then
			private.visible[private.selected].changeOption(-1)
		end
		
		if key == "z" then
			if private.visible == private.main then
				if private.selected == 1 then
					Level = Level1.new()
				elseif private.selected == 2 then
					private.visible = private.options
					private.selected = 1
				end
			end
			if private.visible == private.options then
				if private.selected == 3 then
					selectedmode = modes.modes[private.visible[private.selected].getOption()]
					settings.resolution.w = selectedmode.width
					settings.resolution.h = selectedmode.height
					applySettings()
					print(selectedmode.width .. 'x' .. selectedmode.height)
				end
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