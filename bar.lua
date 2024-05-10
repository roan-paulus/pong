local Bar = { mt = {} }
Bar.mt.__index = Bar

-- Made for fun (can delete)
-- Add two bars together
Bar.mt.__add = function(a, b)
	local t = {}

	t.x = a.x + b.x
	t.y = a.y + b.y
	t.width = a.width + b.width
	t.height = a.height + b.height
	t.speed = a.speed + b.speed

	setmetatable(t, Bar.mt)
	return t
end

function Bar:new(x, y)
	local t = {
		x = x,
		y = y,
		width = 40,
		height = 300,
		speed = 600,
	}
	setmetatable(t, Bar.mt)
	return t
end

function Bar:moveUp(dt)
	self.y = self.y - self.speed * dt
end

function Bar:moveDown(dt)
	self.y = self.y + self.speed * dt
end

function Bar:draw()
	love.graphics.setColor(0, 0.5, 1)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Bar
