Level1 = {}

function Level1.new()
	local private = {}
	local public = {}
	
	world = bump.newWorld(128)
	
	private.entities = {}
	private.entities.player = Player.new('Player 1', 15,15,11,11)
	
	private.objects = {}
	private.objects['block 1'] = Block.new('block 1', 120,120,600,40)
	
	camera = {}
	camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2
	camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2
	
	function public.update(dt)
		camera.x = -private.entities.player.getX() +love.graphics.getWidth()/2
		camera.y = -private.entities.player.getY() +love.graphics.getHeight()/2
		for e, entity in pairs(private.entities) do
			entity.update(dt)
		end
		for o, obj in pairs(private.objects) do
			obj.update(dt)
		end
	end
	
	function public.draw()
		for e, entity in pairs(private.entities) do
			entity.draw()
		end
		for o, obj in pairs(private.objects) do
			obj.draw()
		end
	end
	
	return public
end