love = require("love")
local Bar = require("bar")
local collision = require("collision")
local Ball = require("ball")

function love.load()
	-- Configuration
	local WINNING_SCORE = 5

	love.window.setFullscreen(true)
	love.graphics.setFont(love.graphics.newFont(33))

	game = {
		score = 0,
		running = true,
		win = false,
		lose = false,
	}
	function game:win()
		return self.score >= WINNING_SCORE
	end
	function game:lose()
		return self.score <= -WINNING_SCORE
	end

	screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight(),
	}

	-- Default ball starting location
	X, Y = screen.width / 2, screen.height / 2

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
		opponent = require("opponent"),
		ball = Ball(X, Y),
	}
end

function love.update(dt)
	if not game.running then
		return
	end
	if game:win() or game:lose() then
		game.running = false
		return
	end

	if love.keyboard.isDown("up") and not collision.detect(objects.player, objects.ceiling) then
		objects.player:moveUp(dt)
	end

	if love.keyboard.isDown("down") and not collision.detect(objects.player, objects.floor) then
		objects.player:moveDown(dt)
	end

	objects.ball:update(dt)
	objects.opponent:update(dt)
end

function love.draw()
	objects.player:draw()
	objects.opponent:draw()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(tostring(game.score), screen.width / 2, screen.height / 50)

	if not game.running then
		local HOW_TO_QUIT = "Press 'q' to quit."
		local TEXT_LOCATION = screen.width / 2 - 190
		if game:win() then
			love.graphics.print("You win! " .. HOW_TO_QUIT, TEXT_LOCATION, screen.height / 2)
			return
		elseif game:lose() then
			love.graphics.print("You lose! " .. HOW_TO_QUIT, TEXT_LOCATION, screen.height / 2)
			return
		end
	end

	objects.ball:draw()
end

function love.keypressed(key)
	if key == "d" then
		debug.debug()
	end

	if key == "q" then
		love.event.quit(0)
	end
end
