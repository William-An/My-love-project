tostring = require("lib/inspect")
-- GS       = require("lib/hump.gamestate")
Class    = require("lib/hump.class")
Signal   = require("lib/hump.signal")
Timer    = require("lib/hump.timer")
U        = require("utils")
table.seal(_G)
-- no global variable declaration afterward!!!

local ball = {
	x = 300,
	y = 300,
	vx = 100,
	vy = 100,
	r = 10,
}
local ww, hh = love.graphics.getDimensions()

function reset()

end
love.load = reset

function love.draw()
	love.graphics.print("Helloworld", 300, 400)
	love.graphics.circle("line", ball.x, ball.y, ball.r)
end

function love.update(dt)
	Timer.update(dt)
	ball.x=ball.x+ball.vx*dt
	ball.y=ball.y+ball.vy*dt
	if (hh-ball.y) < ball.r or ball.y<ball.r then 
		ball.vy = -ball.vy
		ball.vy = ball.vy
	end
	if (ww-ball.x) < ball.r or ball.x < ball.r then
		ball.vx = -ball.vx
		ball.vx = ball.vx
	end
end
