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
	private.crosshair = images['crosshair.png']
	private.dir = {}
	private.dir.x = private.x
	private.dir.y = private.y
	
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
		if settings.inputtype == "keyboard" or settings.inputtype == "keyboardmouse" then
			if love.keyboard.isDown(mapping.up) then
				private.yvel = 150
			end
			if love.keyboard.isDown(mapping.down) then
				private.yvel = -150
			end
			if love.keyboard.isDown(mapping.left) then
				private.xvel = 150
			end
			if love.keyboard.isDown(mapping.right)then
				private.xvel = -150
			end
			if love.keyboard.isDown(mapping.primary) then
				private.weapons.selected.reloading = 0
				private.weapons.selected.reloadTmr = 0
				private.shootTimer = 0
				private.weapons.selected = private.weapons.primary
			end
			if love.keyboard.isDown(mapping.secondary) then
				private.weapons.selected.reloading = 0
				private.weapons.selected.reloadTmr = 0
				private.shootTimer = 0
				private.weapons.selected = private.weapons.secondary
			end
			if love.keyboard.isDown(mapping.reload) then
				private.weapons.selected.reloading = 1
			end
			if love.mouse.isDown(1) and private.shootTimer > private.weapons.selected.shootTimer and private.weapons.selected.reloading == 0 then
				private.dir.x = love.mouse.getX()-love.graphics.getWidth()/2
				private.dir.y = love.mouse.getY()-love.graphics.getHeight()/2
				local ang = math.atan2(private.dir.y, private.dir.x)
				private.shoot(ang)
			end
		else
			private.dir.x = joystick:getGamepadAxis("rightx")
			private.dir.y = joystick:getGamepadAxis("righty")
			if joystick:getGamepadAxis("leftx")> 0.3 or joystick:getGamepadAxis("leftx") <-0.3 then
				private.xvel = -joystick:getGamepadAxis("leftx")*150
			else
				private.xvel = 0
			end
			if joystick:getGamepadAxis("lefty") > 0.3 or joystick:getGamepadAxis("lefty") <-0.3 then
				private.yvel = -joystick:getGamepadAxis("lefty")*150
			else
				private.yvel = 0
			end
			if joystick:isGamepadDown(mapping.reload) then
				private.weapons.selected.reloading = 1
			end
			if joystick:isGamepadDown(mapping.accept) and private.shootTimer > private.weapons.selected.shootTimer and private.weapons.selected.reloading == 0 then
				local ang = math.atan2(private.dir.y,private.dir.x)
				private.shoot(ang)
			end
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
		if settings.inputtype == "keyboard" or settings.inputtype == "joystick" then
			if private.dir.x <0.3 or private.dir.x >0.3 then
				if private.dir.y <0.3 or private.dir.y > 0.3 then
					love.graphics.draw(private.crosshair, private.x+camera.x+private.dir.x*50, private.y+camera.y+private.dir.y*50)
				end
			end
		end
	end
	
	return public
end