tostring = require("lib/inspect")
-- GS       = require("lib/hump.gamestate")
Class  = require("lib/hump.class")
Signal = require("lib/hump.signal")
Timer  = require("lib/hump.timer")
Vec    = require("lib/hump.vector")
U      = require("utils")
table.seal(_G)
local Drawable = require("drawable")
local element={
	vx = 100,
	vy = 100,
	w = 1,
	center={10,10},
	o = 0,
	vertice={0,0,20,0,10,20}
}

local direction = {{"up",-element.vy},{"down",element.vy},{"left",-element.vx},{"right",element.vx}}
local ww, hh = love.graphics.getDimensions()
local function reset()
end
love.load = reset

function love.draw()
	love.graphics.polygon("fill",element.vertice)

end

function love.update(dt)
	Timer.update(dt)
	element.vertice={element.center[1]-10,element.center[2]-10,element.center[1]+10,element.center[2]-10,element.center[1],element.center[2]+10} --Calculate vertices coordinate through center
	for i,v in ipairs(direction) do
		if love.keyboard.isDown(v[1]) then
			if i > 2 then
				element.center[1]=element.center[1]+dt*v[2]
			else
				element.center[2]=element.center[2]+dt*v[2]
			end
		end
	end
	--if love.keyboard.isDown("up") then
	--	element.center[2]=element.center[2]-dt*element.vy
	--end
	--if love.keyboard.isDown("down") then
	--	element.center[2]=element.center[2]+dt*element.vy
	--end
	--if love.keyboard.isDown("left") then
	--	element.center[1]=element.center[1]-dt*element.vx
	--end
	--if love.keyboard.isDown("right") then
	--	element.center[1]=element.center[1]+dt*element.vx
	--end
end

function love.keypressed(key)
	Signal.emit("keypressed", key)
end
function love.keyreleased(key)
	Signal.emit("keyreleased", key)
end
