Item = {}

function Item.new(name, x,y,w,h)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.w = w
	private.h = h
	private.r = 0
	private.name = name
	private.image = images['ammocrate.png']
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	function public.update(dt)
		
	end
	
	function public.draw()
		love.graphics.draw(private.image, private.x+camera.x, private.y+camera.y)
	end
	
	return public
end