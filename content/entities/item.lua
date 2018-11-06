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
	private.type = love.math.random(1,2)
	private.value = love.math.random(30, 60)
	if private.type == 1 then
		private.image = images['ammocrate.png']
	else
		private.image = images['money.png']
	end
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	function public.update(dt)
		
	end
	
	function public.draw()
		love.graphics.draw(private.image, private.x+camera.x, private.y+camera.y)
	end

	function public.getType()
		return private.type
	end
	
	function public.getValue()
		return private.value
	end
	return public
end