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
	v = 100, -- s coordinate
	w = 1, -- p coordinate, origin at element.center
	center={10,10},
	o = 0,
	vertice={0,0,20,0,10,20}
	p_vertice={-10,10,10,10,0,-10}
}
p_vertice=element.p_vertice
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
	local temp_vertice={p_vertice[1]*math.cos(element.o)-p_vertice[2]*math.sin(element.o),p_vertice[1]*math.sin(element.o)+p_vertice[2]*math.cos(element.o),
				    	p_vertice[3]*math.cos(element.o)-p_vertice[4]*math.sin(element.o),p_vertice[3]*math.sin(element.o)+p_vertice[4]*math.cos(element.o),
						p_vertice[5]*math.cos(element.o)-p_vertice[6]*math.sin(element.o),p_vertice[5]*math.sin(element.o)+p_vertice[6]*math.cos(element.o)}
	p_vertice=temp_vertice
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
	if element.center[1] < 0 then -- Prevent out of borders
		element.center[1] = ww
	elseif element.center[1] > ww then
		element.center[1] = 0
	elseif element.center[2] < 0 then
		element.center[2] = hh
	elseif element.center[2] > hh then
		element.center[2] = 0
	end

end

function love.keypressed(key)
	Signal.emit("keypressed", key)
end
function love.keyreleased(key)
	Signal.emit("keyreleased", key)
end
