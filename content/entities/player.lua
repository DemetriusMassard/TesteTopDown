Player = {}

function Player.new(name, x,y,w,h)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.h = h
	private.w = w
	private.name = name
	
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	private.yvel = 0
	private.xvel = 0
	
	private.mov = {}
	private.mov.x = x
	private.mov.y = y
	
	function public.getX()
		return private.x
	end
	
	function public.getY()
		return private.y
	end
	
	function public.update(dt)
		private.xvel = 0
		private.yvel = 0
		if love.keyboard.isDown(settings.keyboard.up) then
			private.yvel = 150
		end
		if love.keyboard.isDown(settings.keyboard.down) then
			private.yvel = -150
		end
		if love.keyboard.isDown(settings.keyboard.left) then
			private.xvel = 150
		end
		if love.keyboard.isDown(settings.keyboard.right) then
			private.xvel = -150
		end
		
		private.mov.x = private.x - (private.xvel*dt)
		private.mov.y = private.y - (private.yvel*dt)
		
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, Playerfilter)
		private.x = actX
		private.y = actY
	end
	
	function public.draw()
		love.graphics.rectangle("line", private.x+camera.x, private.y+camera.y,private.w, private.h)
	end
	
	return public
end