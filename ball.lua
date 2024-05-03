local collision = require("collision")
local helper = require("helper")

local properties = {
	dy = 0, -- delta y (vertical displacement)
}

local mt = {}

function mt:__index(key)
	if key == "dy" then
		return properties[key]
	end
	return rawget(self, key)
end

function mt:__newindex(key, val)
	if key == "speed" then
		self[key] = val
	elseif key == "dy" then
		properties[key] = val

		if properties[key] > self.speed then
			properties[key] = self.speed
		elseif properties[key] < -self.speed then
			properties[key] = -self.speed
		end
	else
		rawset(self, key, val)
	end
end

local SPEED = 800

local ball = {
	x = screen.width / 2,
	y = screen.height / 2,
	radius = 10,
	speed = SPEED,
	negative_speed = -SPEED,

	dx = 1000, -- delta x (horizontal displacement)

	update = function(self, dt)
		if collision.detect(self, objects.player) then
			self.dx = -self.dx

			if love.keyboard.isDown("up") then
				local zone = collision.compute_zone(self, objects.player)
				self.dy = self.dy + self.negative_speed * zone * helper.get_slack()
			elseif love.keyboard.isDown("down") then
				local zone = collision.compute_zone(self, objects.player)
				self.dy = self.dy + self.speed * zone * helper.get_slack()
			else
				self.dy = self.dy * 0.9
			end
		elseif collision.detect(self, objects.opponent) then
			self.dx = -self.dx
		elseif collision.detect(self, objects.ceiling) then
			self.dy = -self.dy
		elseif collision.detect(self, objects.floor) then
			self.dy = -self.dy
		elseif collision.detect(self, objects.left_wall) then
			self.dx = -self.dx
			if game.score > 0 then
				game.score = game.score - 1
			end
		elseif collision.detect(self, objects.right_wall) then
			self.dx = -self.dx
			game.score = game.score + 1
		end

		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	end,

	draw = function(self)
		love.graphics.circle("fill", self.x, self.y, self.radius)
	end,
}

setmetatable(ball, mt)

return ball
