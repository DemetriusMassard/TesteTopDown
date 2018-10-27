Block = {}

function Block.new(name, x,y,w,h)
	local private = {}
	local public = {}
	
	private.x = x
	private.y = y
	private.w = w
	private.h = h
	private.name = name
	
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	function public.update(dt)
	
	end
	
	function public.draw()
		love.graphics.rectangle("fill", private.x+camera.x, private.y+camera.y, private.w, private.h)
	end
	
	return public
end