StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}

	self.states = states or {}
	self.current = self.empty
end

function StateMachine:change(stateName, params)
	assert(self.states[stateName]) --state must exist
	self.current:exit() --exit previous state before entering new one
	self.current = self.states[stateName]() --set current state to state passed in by function parameter and then call whatever function is there hence the ()
	self.current:enter(params) -- enter state with optional parameters
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end