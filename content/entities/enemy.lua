Enemy = {}

function Enemy.new(name,x,y)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.w = 15
	private.h = 15
	private.speed = 50
	private.yvel = 0
	private.xvel = 0
	private.name = name
	private.mov = {}
	private.mov.x = private.x
	private.mov.y = private.y
	
	world:add(private.name, private.x, private.y,private.w,private.h)
	
	
	function private.enemyfilter(item, other)
		local name = split(other)
		if name[1] == "bullet" then return false
		elseif name[1] == "Player" or name[1] == "item" or name[1] == "enemy" then return "cross"
		else return "slide"
		end
	end
	
	function public.update(dt)
		--isso já tá virando bagunça
		local player = Level.getEntity("player")
		local ang = math.atan2(private.y-player.getY(), private.x-player.getX())
		private.xvel = math.cos(ang)
		private.yvel = math.sin(ang)
		private.mov.x = private.x-(private.xvel*dt*private.speed)
		private.mov.y = private.y-(private.yvel*dt*private.speed)
		
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, private.enemyfilter)
		
		private.x = actX
		private.y = actY
	end
	
	function public.draw()
		love.graphics.rectangle("fill", private.x+camera.x, private.y+camera.y,private.w, private.h)
	end
	
	
	return public
end