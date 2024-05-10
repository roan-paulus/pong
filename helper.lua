local helper = {}

function helper.get_slack()
	return math.random() * 0.4 + 0.8
end

function helper.set_prev_frame(obj)
	obj.x, obj.y = obj.prev.x, obj.prev.y
	obj.colliding = false
end

return helper
