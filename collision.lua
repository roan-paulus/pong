local collision = {}

---Check if a collides with b
---@param object_a table
---@param y table
---@return boolean
function collision.detect(object_a, y)
	local a = {
		left = object_a.x,
		right = object_a.x + object_a.width,
		top = object_a.y,
		bottom = object_a.y + object_a.height,
	}

	local b = {
		left = y.x,
		right = y.x + y.width,
		top = y.y,
		bottom = y.y + y.height,
	}

	object_a.colliding = true

	return a.right > b.left and a.left < b.right and a.top < b.bottom and a.bottom > b.top
end

function collision.where(x, y)
	local x_center = (x.y * 2 + x.height) / 2
	local y_center = (y.y * 2 + y.height) / 2

	local distance = y_center - x_center

	-- Negative numbers are below the center of object 'y'
	return distance
end

function collision.compute_zone(x, y)
	local ZONE_AMOUNT = 5
	local LENGTH_HALF = y.height / 2
	local ZONE_LENGTH = LENGTH_HALF / ZONE_AMOUNT

	local distance_from_center = math.abs(collision.where(x, y))

	local sizes = {
		one = ZONE_LENGTH,
		two = ZONE_LENGTH * 2,
		three = ZONE_LENGTH * 3,
		four = ZONE_LENGTH * 4,
		five = ZONE_LENGTH * 5,
	}

	if 0 < distance_from_center and distance_from_center < sizes.one then
		return 1
	elseif distance_from_center < sizes.two then
		return 2
	elseif distance_from_center < sizes.three then
		return 3
	elseif distance_from_center < sizes.four then
		return 4
	elseif distance_from_center < sizes.five then
		return 5
	else
		print(string.format("Out of bounds! distance_from_center: %i", distance_from_center))
		return 5
	end
end

return collision
