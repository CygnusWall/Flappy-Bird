ScoreState = Class{__includes = BaseState}

function ScoreState:init()
	self.score = 0
	self.trophy1 = love.graphics.newImage('1st Trophy.png')
	self.trophy2 = love.graphics.newImage('2nd Trophy.png')
	self.trophy3 = love.graphics.newImage('3rd Trophy.png')
	self.medal1 = love.graphics.newImage('1st Medal.png')
	self.medal2 = love.graphics.newImage('2nd Medal.png')
	self.medal3 = love.graphics.newImage('3rd Medal.png')

	
	self.medal_height = self.medal1:getHeight()
	self.medal_width = self.medal1:getWidth()
	self.trophy_height = self.trophy1:getHeight()
	self.trophy_width = self.trophy1:getWidth()

	self.scale = .2

	self.medalx = VIRTUAL_WIDTH / 2 - (self.medal_width / 2) + 225
	self.medaly = VIRTUAL_HEIGHT / 2 - (self.medal_height / 2) + 260
	self.trophyx = VIRTUAL_WIDTH / 2 - (self.trophy_width / 2) + 225
	self.trophyy = VIRTUAL_HEIGHT / 2 - (self.trophy_height / 2) + 270
	
end



function ScoreState:update(dt)
	--this line is probably redundant as we could just print gScore instead
	self.score = gScore

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		--resets score so the player cannot cheat
		gScore = 0
		gStateMachine:change('title')
	end
end

function ScoreState:render()
	love.graphics.setFont(hugeFont)
	self.score = gScore
	love.graphics.printf(tostring(self.score / 2), 0, 30, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(mediumFont)

	if self.score > 50 then
		love.graphics.printf('SECOND TO NONE!!', 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.trophy1, self.trophyx, self.trophyy, 0, self.scale, self.scale)
	elseif self.score > 40 then
		love.graphics.printf('SECOND TO ONE!!', 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.trophy2, self.trophyx, self.trophyy, 0, self.scale, self.scale)
	elseif self.score > 30 then
		love.graphics.printf('OUTSTANDING!!', 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.trophy3, self.trophyx, self.trophyy, 0, self.scale, self.scale)
	elseif self.score > 20 then
		love.graphics.printf("I think you've seen better days", 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.medal1, self.medalx, self.medaly, 0, self.scale, self.scale)
	elseif self.score > 10 then
		love.graphics.printf('Meh, was that your best shot?', 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.medal2, self.medalx, self.medaly, 0, self.scale, self.scale)
	else
		love.graphics.printf("No way, you can't be that bad", 0, 90, VIRTUAL_WIDTH, 'center')
		love.graphics.draw(self.medal3, self.medalx, self.medaly, 0, self.scale, self.scale)
	end

	love.graphics.printf('Press ENTER to return to title screen', 0, 240, VIRTUAL_WIDTH, 'center')
end

