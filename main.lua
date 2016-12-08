tostring = require("lib/inspect")
-- GS       = require("lib/hump.gamestate")
Class  = require("lib/hump.class")
Signal = require("lib/hump.signal")
Timer  = require("lib/hump.timer")
Vec    = require("lib/hump.vector")
U      = require("utils")
table.seal(_G)
-- no global variable declaration afterward!!!

function reset()

end
love.load = reset

function love.draw()

end

function love.update(dt)
	Timer.update(dt)
end

function love.keypressed(key)
	Signal.emit("keypressed", key)
end
function love.keyreleased(key)
	Signal.emit("keyreleased", key)
end
