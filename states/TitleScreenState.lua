TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end

function TitleScreenState:render()
	love.graphics.setFont(largeFont)
	love.graphics.printf('Flappy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press ENTER to begin', 0, 100, VIRTUAL_WIDTH, 'center')
end

