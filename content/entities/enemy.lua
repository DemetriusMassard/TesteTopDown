Enemy = {}

function Enemy.new(name,x,y)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.w = 15
	private.h = 15
	private.speed = love.math.random(30,70)
	private.life = 50
	private.dir = {}
	private.dir.y = 0
	private.dir.x = 0
	private.name = name
	private.mov = {}
	private.mov.x = private.x
	private.mov.y = private.y
	private.knockback = 0
	
	world:add(private.name, private.x, private.y,private.w,private.h)
	
	
	function private.enemyfilter(item, other)
		local name = split(other)
		if name[1] == "bullet" or name[1] == "item" or name[3] == "inv" then return false
		elseif name[1] == "Player" then return "cross"
		else return "slide"
		end
	end
	
	function public.damage(dmg, dirX, dirY)
		private.knockback = 0.5
		private.dir.x = -dirX
		private.dir.y = -dirY
		private.life = private.life-dmg
		if private.life < 0 then
			Level.removeEntity(private.name)
			local chanceItem = love.math.random(0,100)
			if chanceItem > 50 then
				local name = "item " .. Level.getItemCount()
				
				local entities = Level.getEntities()
				entities[name] = Item.new(name, private.x, private.y, 32,32)
				Level.addItemCount()
			end
		end
	end
	
	function public.update(dt)
		private.knockback = private.knockback-dt
		if private.knockback <0 then
			local player = Level.getEntity("player")
			local ang = math.atan2(private.y-player.getY(), private.x-player.getX())
			private.dir.x = math.cos(ang)
			private.dir.y = math.sin(ang)
			private.mov.x = private.x-(private.dir.x*dt*private.speed)
			private.mov.y = private.y-(private.dir.y*dt*private.speed)
		else
			local knockbackForce = love.math.random(100,200)
			private.mov.x = private.x-(private.dir.x*private.knockback*knockbackForce*dt)
			private.mov.y = private.y-(private.dir.y*private.knockback*knockbackForce*dt)	
		end
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, private.enemyfilter)
		
		private.x = actX
		private.y = actY
	end
	
	function public.draw()
		love.graphics.rectangle("fill", private.x+camera.x, private.y+camera.y,private.w, private.h)
	end
	
	
	return public
end