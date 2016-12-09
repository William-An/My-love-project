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
	v = 300, -- translate velocity s coordinate
	w = math.pi, -- angular velocity p coordinate, origin at element.center
	center={10,10},
	o = 0,
	vertice={0,0,20,0,10,20},
	p_vertice={-10,10,10,10,0,-10},
}
local p_vertice=element.p_vertice
local direction = {{"up",element.v},{"down",-element.v},{"left",-element.w},{"right",element.w}}
local ww, hh = love.graphics.getDimensions()
local function reset()
end
love.load = reset

function love.draw()
	love.graphics.polygon("fill",element.vertice)

end
local angle = element.o
function love.update(dt)
	Timer.update(dt)
	Timer.every(4,function()
		element.center={math.floor(math.random(1,ww)),math.floor(math.random(1,hh))}
		Timer.clear()--
	end)
	love.graphics.print(Timer)
	for i,v in ipairs(direction) do
		if love.keyboard.isDown(v[1]) then
			if i > 2 then
				element.o=element.o+dt*v[2]
				angle=angle+element.o
				--angle=math.floor(angle)
				print("[angle]"..angle)
			else
				element.center[1]=element.center[1]+dt*math.sin(angle)*v[2]
				element.center[2]=element.center[2]-dt*math.cos(angle)*v[2]
				-- if angle >= 2*math.pi then
				-- 	angle = 0
				-- end
				--print(angle*180/math.pi)
			end
		end
	end
	
	local temp_vertice={p_vertice[1]*math.cos(element.o)-p_vertice[2]*math.sin(element.o),p_vertice[1]*math.sin(element.o)+p_vertice[2]*math.cos(element.o),
				    	p_vertice[3]*math.cos(element.o)-p_vertice[4]*math.sin(element.o),p_vertice[3]*math.sin(element.o)+p_vertice[4]*math.cos(element.o),
						p_vertice[5]*math.cos(element.o)-p_vertice[6]*math.sin(element.o),p_vertice[5]*math.sin(element.o)+p_vertice[6]*math.cos(element.o)}
	p_vertice=temp_vertice
	element.vertice={element.center[1]+p_vertice[1],element.center[2]+p_vertice[2],element.center[1]+p_vertice[3],element.center[2]+p_vertice[4],element.center[1]+p_vertice[5],element.center[2]+p_vertice[6]} --Calculate vertices coordinate through center
	if element.center[1] < 0 then -- Prevent out of borders
		element.center[1] = ww
	elseif element.center[1] > ww then
		element.center[1] = 0
	elseif element.center[2] < 0 then
		element.center[2] = hh
	elseif element.center[2] > hh then
		element.center[2] = 0
	end
	element.o=0
end

function love.keypressed(key)
	Signal.emit("keypressed", key)
end
function love.keyreleased(key)
	Signal.emit("keyreleased", key)
end
