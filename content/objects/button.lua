Button = {}

function Button.new(x, y,w,h, name, options, label)
	local private = {}
	local public = {}
	public.x = x
	public.y = y
	public.h = h
	public.w = w
	private.name = name
	private.focused = false
	private.options = options
	private.label = label
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
			love.graphics.circle("fill", public.x-35, public.y+(public.h/2), 10)
		end
		--love.graphics.rectangle("line", public.x, public.y, public.w, public.h)
		if private.label then
			love.graphics.printf(private.label, public.x-public.w, public.y+public.h/2-5, public.w, "right")
			love.graphics.printf(private.options[private.selected], public.x, public.y+public.h/2-5, public.w, "center")
		else
			love.graphics.printf(private.options[private.selected], public.x, public.y+public.h/2-5, public.w, "center")
		end
	end
	
	return public
end