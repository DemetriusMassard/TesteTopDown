Block = {}

function Block.new(name, x,y,w,h, visible)
	local private = {}
	local public = {}
	
	private.x = x
	private.y = y
	private.w = w
	private.h = h
	private.name = name
	private.visible = visible
	if not private.visible then
		private.name = private.name .. " inv"
	end
	
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	function public.update(dt)
	
	end
	
	function public.draw()
		if private.visible then
			love.graphics.rectangle("fill", private.x+camera.x, private.y+camera.y, private.w, private.h)
		end
	end
	
	return public
end