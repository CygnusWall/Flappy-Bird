push = require 'push'

WINDOW_WIDTH = 1366
WINDOW_HEIGHT = 768

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local background = love.graphics.newImage('ground.png')

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy Bird')

	push:setupScreen(VIRTUAL_HEIGHT, VIRTUAL_WIDTH, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = false
	})
end 

function love.resize(w, h)
	push:resizable(w, h)
end

function love.keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end