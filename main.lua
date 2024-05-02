_G.love = require("love")
local Bar = require("bar")
local collision = require("collision")

function love.load()
	love.window.setFullscreen(true)

	game = {
		score = 0,
	}

	screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight(),
	}

	-- [[ Define objects ]]
	local PADDING = 99999999
	objects = {
		ceiling = {
			x = 0,
			y = -PADDING,
			width = screen.width,
			-- Fill alot of space above the game so the ball can't jump over collision
			height = PADDING,
		},
		floor = {
			x = 0,
			-- Fill alot of space above the game so the ball can't jump over collision
			y = screen.height,
			width = screen.width,
			height = PADDING,
		},
		left_wall = {
			x = -PADDING,
			y = 0,
			width = PADDING,
			height = screen.height,
		},
		right_wall = {
			x = screen.width,
			y = 0,
			width = PADDING,
			height = screen.height,
		},
		player = Bar:new(20, 200),
		opponent = Bar:new(0, 200),
		ball = require("ball"),
	}

	objects.opponent.x = screen.width - objects.opponent.width

	-- Set a width and height to conform to what collision expects for now...
	objects.ball.width = objects.ball.radius * 2
	objects.ball.height = objects.ball.width
end

function love.update(dt)
	if love.keyboard.isDown("up") and not collision.detect(objects.player, objects.ceiling) then
		objects.player:moveUp(dt)
	end

	if love.keyboard.isDown("down") and not collision.detect(objects.player, objects.floor) then
		objects.player:moveDown(dt)
	end

	objects.ball:update(dt)
end

function love.draw()
	objects.player:draw()
	objects.opponent:draw()
	objects.ball:draw()

	love.graphics.print(tostring(game.score), screen.width / 2, screen.height / 50)
end

function love.keypressed(key)
	if key == "d" then
		debug.debug()
	end

	if key == "q" then
		love.event.quit(0)
	end
end
