ScoreState = Class{__includes = BaseState}

function ScoreState:init()
	self.score = 0
	self.bird = Bird()
    self.pipePairs = {}
end

function ScoreState:update(dt)
	self.score = gScore

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('title')
	end
end

function ScoreState:render()
	love.graphics.setFont(hugeFont)
	self.score = gScore
	love.graphics.printf(tostring(self.score / 2), 0, 30, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press ENTER to return to title screen', 0, 90, VIRTUAL_WIDTH, 'center')
end

