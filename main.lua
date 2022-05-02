--library required to use virtual resolution
push = require "push"
--library required to use classes
Class = require "class"

--user defined classes
require "Bird"

require "Pipe"

require "PipePair"

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

--table of pipe pairs
local pipePairs = {}

--timer for when pipe spawns
local timer = 0

--sotrs the last y of the pipe gap so that the sucessive pipe isin't spawned too far from it making the game much more dificult
local lastY = -PIPE_HEIGHT + math.random(80) + 20

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

	--creates a table of keys pressed
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

	--increments the timer by dt which I think is a small fraction of a second
	timer = timer + dt

	if timer > 2 then

		local y = math.max(-PIPE_HEIGHT + 47, 
			math.min(lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 121 -PIPE_HEIGHT))
		lastY = y

		--spawns a pipe then resets the timer to 0 so that another pipe can be spawned
		table.insert(pipePairs, PipePair(y))
		timer = 0
	end

	bird:update(dt)
	
	--updating the pipes so they scroll on screen
	for k, pair in pairs (pipePairs) do
 		pair:update(dt)
	end

	--removing the pipes when they cross the left bound of the screen
	for k, pair in pairs (pipePairs) do
 		if pair.remove then
 			table.remove(pipePairs, k)
 		end
	end

	--clears the last stored key at the end of every frame so that a new one can be accepted
	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()
	--draws background and ground, they move because the x values are variables
	love.graphics.draw(background, -backgroundScroll, 0)

	--renders the pipes onto the screen
	for k, pair in pairs(pipePairs) do
		pair:render()
	end

	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	--user defined function for drawing the bird, see the class for more info
	bird:render()

	push:finish()
end