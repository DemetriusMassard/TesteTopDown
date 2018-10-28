Button = {}

function Button.new(x, y,w,h, name, options)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.h = h
	private.w = w
	private.name = name
	private.focused = false
	private.options = options
	private.selected = 1
	
	
	function public.changeOption(option)
		private.selected = private.selected+option
		if private.selected == 0 then
			private.selected = table.getn(private.options)
		elseif private.selected == table.getn(private.options)+1 then
			private.selected = 1
		end
	end
	
	function public.getOption()
		return private.selected
	end
	
	function public.focus()
		private.focused = true
	end
	
	function public.unfocus()
		private.focused = false
	end
	
	function public.draw()
		if private.focused then
			love.graphics.circle("fill", private.x-35, private.y+(private.h/2), 10)
		end
		love.graphics.rectangle("line", private.x, private.y, private.w, private.h)
		love.graphics.printf(private.options[private.selected], private.x, private.y+private.h/2-5, private.w, "center")
	end
	
	return public
end