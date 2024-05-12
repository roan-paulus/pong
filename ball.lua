local collision = require("collision")
local helper = require("helper")

local Ball = {
	VISUAL_CORRECTION_OFFSET = 12,
}
Ball.mt = {}

function Ball.mt:__call(x, y, tabl, radius, speed)
	-- Defaults
	local SPEED = 800

	if tabl == nil then
		tabl = {}
	end

	t = {
		x = x,
		y = y,
		prev = { x = x, y = y },
		radius = radius or 10,
		speed = speed or SPEED,
		colliding = false,
		dx = speed or SPEED,
		dy = tabl.dy or 0,
		acceleration = 500,
	}

	if tabl.reverse then
		t.dx = -t.dx
	end

	-- Calculated attributes
	t.negative_acceleration = -t.acceleration
	t.negative_speed = -t.speed
	t.width = t.radius * 2
	t.height = t.width

	setmetatable(t, { __index = Ball })

	return t
end

setmetatable(Ball, Ball.mt)

function Ball:update(dt)
	-- Old location
	self.prev.x = self.x
	self.prev.y = self.y

	self:set_next_location(dt)

	if collision.detect(self, objects.player) then
		self:collide_player()
	elseif collision.detect(self, objects.opponent) then
		self:reverse_horizontal_direction()
		self.x = objects.opponent.x - self.VISUAL_CORRECTION_OFFSET
	elseif collision.detect(self, objects.ceiling) or collision.detect(self, objects.floor) then
		self:reverse_vertical_direction()
	elseif collision.detect(self, objects.left_wall) then
		self:reverse_horizontal_direction()
		if game.score > 0 then
			game.score = game.score - 1
		end
	elseif collision.detect(self, objects.right_wall) then
		self:reverse_horizontal_direction()
		game.score = game.score + 1
	end

	-- if self.colliding then
	-- 	helper.set_prev_frame(self)
	-- end
end

function Ball:set_next_location(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
end

function Ball:collide_player()
	self:reverse_horizontal_direction()

	self.x = objects.player.x + objects.player.width + self.VISUAL_CORRECTION_OFFSET

	if love.keyboard.isDown("up") then
		local zone = collision.compute_zone(self, objects.player)
		self:set_dy(self.dy + self.negative_acceleration * zone * helper.get_slack())
	elseif love.keyboard.isDown("down") then
		local zone = collision.compute_zone(self, objects.player)
		self:set_dy(self.dy + self.acceleration * zone * helper.get_slack())
	else
		self:set_dy(self.dy * 0.9)
	end
end

function Ball:set_dy(num_val)
	if num_val > self.speed then
		self.dy = self.speed
	elseif num_val < self.negative_speed then
		self.dy = self.negative_speed
	else
		self.dy = num_val
	end
end

function Ball:reverse_horizontal_direction()
	self.dx = -self.dx
end

function Ball:reverse_vertical_direction()
	self.dy = -self.dy
end

function Ball:draw()
	love.graphics.setColor(0.8, 0.5, 0) -- purple
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
