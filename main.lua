function love.load()
	require 'content/entities/player'
	
	local objects = love.filesystem.getDirectoryItems('content/objects')
	for i, o in pairs(objects) do
	
		trim = string.gsub( o, ".lua", "")
		require('content/objects/' .. trim)
	end
	
	local entities = love.filesystem.getDirectoryItems('content/entities')
	for i, e in pairs(entities) do
	
		trim = string.gsub( e, ".lua", "")
		require('content/entities/' .. trim)
	end
	
	local levels = love.filesystem.getDirectoryItems('levels')
	for i, l in pairs(levels) do
	
		trim = string.gsub( l, ".lua", "")
		require('levels/' .. trim)
	end
	
	bump = require('bump')
	Level = Menu.new()
end

function love.update(dt)
	Level.update(dt)
end

function love.draw()
	Level.draw()
end

function love.keypressed(key, unicode)
	Level.keypressed(key, unicode, nil, nil)
end

function split(text, delim)
    -- returns an array of fields based on text and delimiter (one character only)
    local result = {}
    local magic = "().%+-*?[]^$"

    if delim == nil then
        delim = "%s"
    elseif string.find(delim, magic, 1, true) then
        -- escape magic
        delim = "%"..delim
    end

    local pattern = "[^"..delim.."]+"
    for w in string.gmatch(text, pattern) do
        table.insert(result, w)
    end
    return result
end