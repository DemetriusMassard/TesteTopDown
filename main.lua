function love.load()
	require 'content/entities/player'
	require 'levels/level1'
	require 'content/objects/block'
	bump = require('bump')
	Level = Level1.new()
end

function love.update(dt)
	Level.update(dt)
end

function love.draw()
	Level.draw()
end