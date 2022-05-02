Bird = Class{}

--constants
local GRAVITY = 13
local JUMP_FORCE = -250

--is called when an object is created
function Bird:init()
	self.image = love.graphics.newImage('bird.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	--sets the x and y positions to the center of the screen
	self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
	self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

	self.dy = 0
end

function Bird:render()
	--draws the bird at the center of the screen
	love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
	--increments gravity by itself every frame(scaled by delta time)
	self.dy = self.dy + GRAVITY * dt

	--space is passed as a parameter because we want the bird to jump when space is pressed
	if love.keyboard.wasPressed('space') then
		self.dy = self.dy + JUMP_FORCE * dt
	end

	--increments the y pos of the bird every frame
	self.y = self.y + self.dy
end


