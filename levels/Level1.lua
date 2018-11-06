Level1 = {}

function Level1.new()
	local private = {}
	local public = {}
	
	world = bump.newWorld(128)
	
	private.waves = {}
	private.waves.timer = 0
	private.waves.current = 1
	private.waves[1] = 10
	private.waves[2] = 30
	private.waves[3] = 55
	private.waves[4] = 90
	private.waves[5] = 130
	
	
	private.entities = {}
	private.entities.player = Player.new('Player 1', 15,50,16,16)
	private.entities['spawner 1'] = Spawner.new(250,150, 0.5)
	
	private.enemyCount = 0
	private.itemCount = 0
	
	fps = love.timer.getFPS()
	
	private.objects = {}
	private.objects['block 1'] = Block.new('block 1', 100,100,40,250,true)
	private.objects['block 2'] = Block.new('block 2', 100,350,290,40,true)
	private.objects['block 3'] = Block.new('block 3', 350,100,40,250,true)
	private.objects['block 4'] = Block.new('block 4', 100,100,290,40,false)
	
	camera = {}
	camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2+(private.entities.player.getW()/2)
	camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2+(private.entities.player.getH()/2)
	
	function public.update(dt)
		private.waves.timer = private.waves.timer + dt
		if private.waves.timer > 30 then
			public.nextWave()
		end
		
		for e, entity in pairs(private.entities) do
			entity.update(dt)
		end
		
		for o, obj in pairs(private.objects) do
			obj.update(dt)
		end
		camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2
		camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2
		fps = love.timer.getFPS()
	end
	
	function public.getEntity(name)
		return private.entities[name]
	end
	
	function public.removeEntity(name)
		world:remove(name)
		private.entities[name] = nil
	end
	
	function public.getEntities()
		return private.entities
	end
	
	function public.getEnemyCount()
		return private.enemyCount
	end
	
	function public.addEnemyCount()
		private.enemyCount = private.enemyCount + 1
	end
	
	function public.getCurrentWave()
		return private.waves[private.waves.current]
	end
	
	function public.nextWave()
		private.waves.current = private.waves.current + 1
		private.waves.timer = 0
	end
	
	function public.getItemCount()
		return private.itemCount
	end
	
	function public.addItemCount()
		private.itemCount = private.itemCount + 1
	end
	
	function public.draw()
		love.graphics.printf(fps, 0, 20, love.graphics.getWidth(), "right" )
		for e, entity in pairs(private.entities) do
			entity.draw()
		end
		for o, obj in pairs(private.objects) do
			obj.draw()
		end
	end
	
	function public.keypressed(key,unicode)
	
	end
	
	return public
end