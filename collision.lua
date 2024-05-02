local collision = {}

---Check if a collides with b
---@param x table
---@param y table
---@return boolean
function collision.detect(x, y)
	local a = {
		left = x.x,
		right = x.x + x.width,
		top = x.y,
		bottom = x.y + x.height,
	}

	local b = {
		left = y.x,
		right = y.x + y.width,
		top = y.y,
		bottom = y.y + y.height,
	}

	return a.right > b.left and a.left < b.right and a.top < b.bottom and a.bottom > b.top
end

function collision.where(x, y)
	local x_center = (x.y + x.height) / 2
	local y_center = (y.y + y.height) / 2

	local distance = y_center - x_center

	-- Negative numbers are below the center of object 'y'
	return distance
end

local Zone = {
	"ONE",
	"TWO",
	"THREE",
}

function collision.zone(x, y)
	local distance_from_center = collision.where(x, y)
	-- TODO: FINISH FUNCTION
	if 0 < math.abs(distance_from_center) < y.height then
		return Zone.ONE
	end
end

return collision
