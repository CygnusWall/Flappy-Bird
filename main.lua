--library required to use virtual resolution
push = require "push"
--library required to use classes
Class = require "class"

--user defined classes
require "Bird"
require "Pipe"
require "PipePair"

require "StateMachine"
require "states/BaseState"
require "states/PlayState"
require "states/TitleScreenState"
require "states/CountdownState"
require "states/ScoreState"

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

--pauses the game when we collide with a pipe
local scrolling = true

--is called when the game loads
function love.load()
	--disables interpolation giving us a crisp pixel art look
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy Bird')

	smallFont = love.graphics.newFont('font.ttf', 8)
	mediumFont = love.graphics.newFont('flappy.ttf', 14)
	largeFont = love.graphics.newFont('flappy.ttf', 28)
	hugeFont = love.graphics.newFont('flappy.ttf', 56)
	love.graphics.setFont(largeFont)

	sounds = {
		['jump'] = love.audio.newSource('Jump.wav', 'static'),
		['score'] = love.audio.newSource('Score.wav', 'static'),
		['hurt'] = love.audio.newSource('Hurt.wav', 'static'),

		['music'] = love.audio.newSource('gamemusic.mp3', 'static')
	}

	sounds['music']:setLooping(true)
	sounds['music']:play()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false
	})

	gStateMachine = StateMachine {
		['title'] = function() return TitleScreenState() end,
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end,
		['countdown'] = function() return CountdownState() end
	}

	gStateMachine:change('title')

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

	if scrolling then
		backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% BACKGROUND_LOOPING_POINT 

		groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
		% VIRTUAL_WIDTH

		--update the state machine
		gStateMachine:update(dt)
	end	
	--clears the last stored key at the end of every frame so that a new one can be accepted
	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()
	--draws background and ground, they move because the x values are variables
	love.graphics.draw(background, -backgroundScroll, 0)

	gStateMachine:render()
	
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	push:finish()

end