--- My own utility functions
local utils = {}

-- check is userdata and is certain type of LÖVE object
-- @param _type nil or string
function utils.is_u(x, _type)
	return type(x)=="userdata" and (not _type or x:typeOf(_type))
end

function utils.is_s(x)
	return type(x)=="string"
end

function utils.is_n(x)
	return type(x)=="number"
end

function utils.is_f(x)
	return type(x)=="function"
end

function utils.is_t(x)
	return type(x)=="table"
end

-------------------------------------

function math.round(n)
	return math.floor(n + 0.5)
end

-------------------------------------

-- ... more arguments
function table.foreach(list, apply, ...)
	for i,v in ipairs(list) do
		apply(v, ...)
	end
end

function table.contains(t, val)
	for i,v in ipairs(t) do
		if v == val then 
			return true
		end
	end
	return false
end

--- Seal a table
function table.seal(t)
    assert(utils.is_t(t))
    local mt = getmetatable(t)
    if not mt then
        mt = {}
        setmetatable(t,mt)
    else
        assert(not mt.__newindex, 'This table already has __newindex metamethod.')
    end
    mt.__newindex = function(t,k,v)
        error(('Try to temper with sealed table index <%s> with value <%s>'):format(k, v))
    end
    return t
end

function table.proxy(t, accept_fields)
	local proxy_mt = {}
	function proxy_mt:__index(key)
		if table.contains(accept_fields, key) then
			return t[key]
		else
			return rawget(self, key)
		end
	end
	function proxy_mt:__newindex(key, value)
		if table.contains(accept_fields, key) then
			t[key] = value
		else
			rawset(self, key, value)
		end
	end
	return setmetatable({}, proxy_mt)
end

-------------------------------------

local weak_k_mt = {__mode = 'v'}
function utils.weak_v()
	return setmetatable({}, weak_k_mt)
end

function utils.new_debug_image(width, height, fill_color)
	local image_data = love.image.newImageData(width, height)
	fill_color = fill_color or {255, 255, 255}
	for x=0,width-1 do
		for y=0,height-1 do
			image_data:setPixel(x, y, unpack(fill_color))
		end
	end
	return love.graphics.newImage(image_data)
end

-- is point in polygon?
function utils.pnpoly(vertices, x, y)
	local nvert = #vertices/2
	local inside, i, j = false, 1, nvert
	while i <= nvert do
		local vxi, vyi, vyj = vertices[i*2-1], vertices[i*2], vertices[j*2]
		if (((vyi > y) ~= (vyj > y)) and
				(x < (vertices[j*2-1]-vxi) * (y-vyi) / (vyj-vyi) + vxi)) then
			inside = not inside
		end
		j = i
		i = i + 1
	end
	return inside
end

function utils.key_as_analog(left,right,up,down)
	local dx, dy = 0, 0
	if love.keyboard.isDown(left)  then dx = dx - 1 end
	if love.keyboard.isDown(right) then dx = dx + 1 end
	if love.keyboard.isDown(up)    then dy = dy - 1 end
	if love.keyboard.isDown(down)  then dy = dy + 1 end
	return dx, dy
end

-- https://github.com/stevedonovan/Penlight/blob/master/lua/pl/path.lua#L286
function utils.format_path(path, sep)
	path = path:gsub('\\', '/')
	sep = sep or '/'
	local np_gen1, np_gen2 = '[^SEP]+SEP%.%.SEP?','SEP+%.?SEP'
	local np_pat1, np_pat2 = np_gen1:gsub('SEP',sep), np_gen2:gsub(sep,'/')
	local k

	repeat -- /./ -> /
		path,k = path:gsub(np_pat2,'/')
	until k == 0

	repeat -- A/../ -> (empty)
		path,k = path:gsub(np_pat1,'')
	until k == 0

	if path == '' then path = '.' end

	return path
end

function utils.find_module(module_name)
	local sub_path = module_name:gsub('%.', '/')
	for path in package.path:gmatch("[^;]+") do
		local filename = utils.format_path(path:gsub("%?", sub_path))
		if love.filesystem.exists(filename) then
			return filename
		end
	end
	return nil
end

--- Hot reload
local modify_time = {}
function utils.reload(module_name)
	local complete_fn = utils.find_module(module_name)
	assert(complete_fn, "Module '"..module_name.."' does not exist.")
	local last_mod = love.filesystem.getLastModified(complete_fn)
	if last_mod ~= modify_time[module_name] then
		modify_time[module_name] = last_mod
		package.loaded[module_name] = nil
		log.debug(("Load %s"):format(module_name))
	end
	return require(module_name)
end

function utils.simple_ds(template)
	local class = Class()
	class._template = template
	function class:init(...) 
		assert(#self._template == select(..., '#'), "Argument number not match.")
		for i,v in ipairs(self._template) do
			self[v] = select(..., i)
		end
	end
end

-- 1-based
function utils.index2xy(index, width)
	local y = math.floor((index - 1) / width)
	local x = index - y * width
	return x, y+1
end

-- 0-based
function utils.index2xy0(index, width)
	local y = math.floor(index / width)
	local x = index - y * width
	return x, y
end

utils.f = string.format

return utils
