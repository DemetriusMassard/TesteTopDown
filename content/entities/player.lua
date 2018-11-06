Player = {}

function Player.new(name, x,y,w,h)
	local private = {}
	local public = {}
	private.x = x
	private.y = y
	private.h = h
	private.w = w
	private.name = name
	private.money = 0
	
	private.weapons = {}
	
	private.weapons.primary = Pistol.new()
	private.weapons.secondary = Weapon.new()
	
	private.weapons.selected = private.weapons.primary
	
	world:add(private.name, private.x, private.y, private.w, private.h)
	
	private.yvel = 0
	private.xvel = 0
	
	private.mov = {}
	private.mov.x = x
	private.mov.y = y
	
	private.bullets = {}
	private.bulletcount = 0
	private.shootTimer = 0
	
	function public.update(dt)
		private.shootTimer = private.shootTimer + dt
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
		if love.keyboard.isDown(settings.keyboard.primary) then
			private.weapons.selected.reloading = 0
			private.weapons.selected.reloadTmr = 0
			private.shootTimer = 0
			private.weapons.selected = private.weapons.primary
		end
		if love.keyboard.isDown(settings.keyboard.secondary) then
			private.weapons.selected.reloading = 0
			private.weapons.selected.reloadTmr = 0
			private.shootTimer = 0
			private.weapons.selected = private.weapons.secondary
		end
		if love.keyboard.isDown(settings.keyboard.reload) then
			private.weapons.selected.reloading = 1
		end
		
		if private.weapons.selected.reloading == 1 then
			private.weapons.selected.reload(dt)
		end
		
		private.mov.x = private.x - (private.xvel*dt)
		private.mov.y = private.y - (private.yvel*dt)
		
		local actX, actY, cols, len = world:move(private.name, private.mov.x, private.mov.y, private.playerfilter)
		private.x = actX
		private.y = actY
		
		for c, col in pairs(cols) do
			local name = split(col.other)
			if name[1] == "item" then
				local item = Level.getEntity(col.other)
				local type = item.getType()
				if type == 1 then
					private.weapons.selected.resMags = private.weapons.selected.resMags + private.weapons.selected.magMax
					if private.weapons.selected.resMags > private.weapons.selected.resMagsMax then
						private.weapons.selected.resMags = private.weapons.selected.resMagsMax
					end
				else
					private.money = private.money + item.getValue()
				end
				Level.removeEntity(col.other)
			end
		end
		
		for b,bullet in pairs(private.bullets) do
			bullet.update(dt)
		end
		
		if love.mouse.isDown(1) and private.shootTimer > private.weapons.selected.shootTimer and private.weapons.selected.reloading == 0 then
		
			local dir = {}
			dir.x = love.mouse.getX()-love.graphics.getWidth()/2
			dir.y = love.mouse.getY()-love.graphics.getHeight()/2
			local ang = math.atan2(dir.y, dir.x)
			private.shoot(ang)
		end
	end
	
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
	
	function public.getW()
		return private.w
	end
	function public.getH()
		return private.h
	end
	
	function private.shoot(ang)
		if private.weapons.selected.mag>0 then
			private.bulletcount = private.bulletcount + 1
			local name = "bullet " .. private.bulletcount
			
			private.shootTimer = 0
			local dmg = love.math.random(private.weapons.selected.dmgMin, private.weapons.selected.dmgMax)
			local newBullet = Bullet.new(private.x, private.y, ang,dmg, name)
			private.bullets[name] = newBullet
			private.weapons.selected.mag = private.weapons.selected.mag -1
		end
	end

	function public.draw()
		love.graphics.rectangle("line", math.floor(private.x+camera.x), math.floor(private.y+camera.y),private.w, private.h)
		love.graphics.printf("$ " .. private.money, 0, 0, love.graphics.getWidth(), "right" )
		
		love.graphics.print(private.weapons.selected.mag .. "\t/" .. private.weapons.selected.resMags,0,0)
		for b,bullet in pairs(private.bullets) do
			bullet.draw()
		end
	end
	
	return public
end