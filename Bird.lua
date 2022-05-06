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
	self.xpos = VIRTUAL_WIDTH / 2
	self.rot = 0

	self.dy = 0
end

function Bird:render()
	--draws the bird at the center of the screen
	love.graphics.draw(self.image, self.x, self.y, math.deg(self.rot), 1, 1, self.width / 2, self.height / 2)
end

function Bird:update(dt)
	--increments gravity by itself every frame(scaled by delta time)
	self.dy = self.dy + GRAVITY * dt

	--space is passed as a parameter because we want the bird to jump when space is pressed
	if love.keyboard.wasPressed('space') then
		--rotates the bird upward everytime spacebar is pressed
		self.dy = self.dy + JUMP_FORCE * dt
		self.rot  = self.rot - 0.004
		sounds['jump']:play()
	end

	--increments the y pos of the bird every frame
	self.y = self.y + self.dy

	--runs every certain amount of frames, change the first '1' for different results
	if gTest % 1 <= 1 then
		--if bird is over-rotating downwards then reset the position so it cannot rotate any further
		if self.rot > 0.001 then
			self.rot = self.rot
		else
			--if not then rotate it some more
			self.rot = self.rot + 0.0002
		end
	end

	--if bird is over-rotating upwards nudge it down some
	if self.rot < - 0.003 then
		self.rot = self.rot + 0.0002
	end
end

function Bird:collides(pipe)
	if(self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
		if(self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
			sounds['hurt']:play()
			return true
			
		end
	else
		return false
	end
end 

function Bird:passes(pipe)
	if self.x + (self.width / 2) > pipe.x + PIPE_WIDTH then
		if self.x + (self.width / 2) < pipe.x + PIPE_WIDTH + 1 then
			sounds['score']:play()
			return true
			
		end
			--return true
	end

end
