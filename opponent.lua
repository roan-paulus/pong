local Bar = require("bar")
local collision = require("collision")

local opponent = Bar:new(0, 200)

opponent.speed = 500
opponent.x = screen.width - opponent.width

function opponent:update(dt)
	local floor_collision = collision.detect(self, objects.floor)
	local ceiling_collision = collision.detect(self, objects.ceiling)

	if floor_collision then
		self.y = screen.height - self.height
	elseif ceiling_collision then
		self.y = 1
	else
		-- Follow the ball
		local middle_y = self.y + self.height / 2

		local offset = 5
		if middle_y > objects.ball.y + offset then
			self:moveUp(dt)
		elseif middle_y < objects.ball.y - offset then
			self:moveDown(dt)
		end
	end
end

return opponent
