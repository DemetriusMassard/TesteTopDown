Bullet = {}

function Bullet.new(x,y,ang, dmg, name)
	local private = {}
	local public = {}
	private.speed = 300
	private.x = x
	private.y = y
	private.w = 2
	private.h = 2
	private.dir = {}
	private.dir.x = math.cos(ang)
	private.dir.y = math.sin(ang)
	private.name = name
	private.dmg = dmg
	
	private.mov = {}
	private.mov.x = private.x
	private.mov.y = private.y
	
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	function private.bulletfilter(item, other)
		local name = split(other)
		if name[1] == "Player" or name[1] == "bullet" or name[1] == "item" then return false
		else return "touch"
		end
	end
	
	function public.update(dt)
		private.mov.x = private.x + private.speed*private.dir.x*dt
		private.mov.y = private.y + private.speed*private.dir.y*dt
		
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, private.bulletfilter)
		private.x = actX
		private.y = actY
		
		for c, col in pairs(cols) do
			local name = split(col.other)
			if name[1] == "enemy" then
				local enemy = Level.getEntity(col.other)
				enemy.damage(private.dmg,private.dir.x, private.dir.y)
			end
			removeBullet(private.name)
		end
		
	end
	
	function public.draw()
		love.graphics.rectangle("line", private.x+camera.x, private.y+camera.y, private.w,private.h)
	end
	
	
	return public
end