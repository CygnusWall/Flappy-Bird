PlayState = Class{__includes = BaseState}

--speed at which the pipe moves across the screen
PIPE_SCROLL = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

        if self.timer > 2 then

            local y = math.max(-PIPE_HEIGHT + 47, 
                math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 121 -PIPE_HEIGHT))
            self.lastY = y

            --spawns a pipe then resets the timer to 0 so that another pipe can be spawned
            table.insert(self.pipePairs, PipePair(y))
            self.timer = 0
        end

        --updating the pipes so they scroll on screen
        for k, pair in pairs (self.pipePairs) do
            pair:update(dt)
        end

        --removing the pipes when they cross the left bound of the screen
        for k, pair in pairs (self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        self.bird:update(dt)

        for k, pair in pairs(self.pipePairs) do
            --check to see if bird collided with the pipe
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    gStateMachine:change('title')
                end
            end
        end

        --reset if bird hits the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            gStateMachine:change('title')
        end
end

function PlayState:render()
    for k, pair in pairs (self.pipePairs) do
        pair:render()
    end

    self.bird:render()
end
    