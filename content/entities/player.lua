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
	
	private.bullets = {}
	private.bulletcount = 0
	private.shoottimer = 0
	
	function removeBullet(name)
		world:remove(name)
		private.bullets[name] = nil
	end
	
	function private.playerfilter(item, other)
		local name = split(other)
		if name[1] == "bullet" then return false
		elseif name[1] == "item" or name[1] == "enemy" then return "cross"
		else return "slide"
		end
	end
	
	function public.getX()
		return private.x
	end
	
	function public.getY()
		return private.y
	end
	
	function public.update(dt)
		private.shoottimer = private.shoottimer + dt
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
		
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, private.playerfilter)
		private.x = actX
		private.y = actY
		
		for b,bullet in pairs(private.bullets) do
			bullet.update(dt)
		end
		
		if love.mouse.isDown(1) and private.shoottimer > 0.3 then
			local dir = {}
			dir.x = love.mouse.getX()-love.graphics.getWidth()/2
			dir.y = love.mouse.getY()-love.graphics.getHeight()/2
			local ang = math.atan2(dir.y, dir.x)
			
			private.bulletcount = private.bulletcount + 1
			local name = "bullet " .. private.bulletcount
			
			private.shoottimer = 0
			local newBullet = Bullet.new(private.x, private.y, ang, name, private)
			private.bullets[name] = newBullet
		end
		
		
	end
	
	function public.draw()
		love.graphics.rectangle("line", private.x+camera.x, private.y+camera.y,private.w, private.h)
		
		for b,bullet in pairs(private.bullets) do
			bullet.draw()
		end
		
	end
	
	return public
end