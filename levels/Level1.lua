Level1 = {}

function Level1.new()
	local private = {}
	local public = {}
	
	world = bump.newWorld(128)
	
	private.entities = {}
	private.entities.player = Player.new('Player 1', 15,50,16,16)
	private.entities['spawner 1'] = Spawner.new(250,50, 5)
	
	private.enemyCount = 0
	private.itemCount = 0
	
	fps = love.timer.getFPS()
	
	private.objects = {}
	private.objects['block 1'] = Block.new('block 1', 120,120,600,40)
	private.objects['block 2'] = Block.new('block 2', 120,-120,40,300)
	private.objects['block 3'] = Block.new('block 3', 520,-120,40,300)
	
	camera = {}
	camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2+(private.entities.player.getW()/2)
	camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2+(private.entities.player.getH()/2)
	
	function public.update(dt)
		camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2
		camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2
		
		for e, entity in pairs(private.entities) do
			entity.update(dt)
		end
		
		for o, obj in pairs(private.objects) do
			obj.update(dt)
		end
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
	
	function public.getItemCount()
		return private.itemCount
	end
	
	function public.addItemCount()
		private.itemCount = private.itemCount + 1
	end
	
	function public.draw()
		love.graphics.printf(fps, 0, 0, love.graphics.getWidth(), "right" )
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