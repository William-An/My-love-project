local Drawable = Class()

function Drawable:init(pos, image)
	self.pos = pos
	self.image = love.graphics.newImage(image)
end

function Drawable:draw()
	love.graphics.draw(self.image, self.pos.x, self.pos.y)
end

return Drawable
