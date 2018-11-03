Spawner = {}

function Spawner.new(x,y, timerMax)
	local private = {}
	local public = {}
	private.timer = 0
	private.timerMax = timerMax
	private.x = x
	private.y = y
	
	
	function public.update(dt)
		count = Level.getEnemyCount()
		local name = "enemy " .. count
		private.timer = private.timer+dt
		if private.timer > private.timerMax then
			private.timer = 0
			local entities = Level.getEntities()
			entities[name] = Enemy.new(name, private.x, private.y)
			Level.addEnemyCount()
		end
		
	end
	
	function public.draw()
	
	end
	return public
end