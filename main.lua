--library required to use virtual resolution
push = require "push"
--library required to use classes
Class = require "class"

--user defined classes
require "Bird"

require "Pipe"

--constants
WINDOW_WIDTH = 1366
WINDOW_HEIGHT = 768

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--variables
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 569

--seeds the random number generator
math.randomseed(os.time())

--making a bird object from the bird class
local bird = Bird()

local pipes = {}

local timer = 0

--is called when the game loads
function love.load()
	--disables interpolation giving us a crisp pixel art look
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy Bird')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false
	})

	love.keyboard.keysPressed = {}
end 

function love.resize(w, h)
	push:resizable(w, h)
end

function love.keypressed(key)
	--keeps track of when a key is pressed
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

--sorta stores the key that was pressed for later comparison, not totally sure
function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

--is called once every frame
function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
	% BACKGROUND_LOOPING_POINT 

	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
	% VIRTUAL_WIDTH

	timer = timer + dt

	if timer > 2 then
		table.insert(pipes, Pipe())
		timer = 0
	end

	bird:update(dt)
	
	for k, pipe in pairs (pipes) do
 		pipe:update(dt)

 		if pipe.x < - pipe.width then
 			table.remove(pipes, k)
 		end
	end

	--clears the last stored key at the end of every frame so that a new one can be accepted
	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()
	--draws background and ground, they move because the x values are variables
	love.graphics.draw(background, -backgroundScroll, 0)

	for k, pipe in pairs(pipes) do
		pipe:render()
	end

	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	--user defined function for drawing the bird, see the class for more info
	bird:render()

	push:finish()
end