---@class Rect
Rect = {
    __cname = "Rect"
}

setmetatable(Rect, Rect)

function Rect.new(x, y, width, height)
    local r = {}
    r.x = x or 0
    r.y = y or 0
    r.width = width or 0
    r.height = height or 0
    setmetatable(r,Rect)
    return r
end

function Rect.zero()
    return Rect.new(0, 0, 0, 0)
end

function Rect:getPosition()
    return Vector2.new(self.x, self.y)
end

function Rect:setPosition(position)
    self.x = position.x
    self.y = position.y
end

function Rect:getCenter()
    return Vector2.new(self.x + self.width / 2, self.y + self.height / 2)
end

function Rect:setCenter(center)
    self.x = center.x - self.width / 2
    self.y = center.y - self.height / 2
end

function Rect:getMin()
    return Vector2.new(self.x, self.y)
end

function Rect:setMin(min)
    self.x = min.x
    self.y = min.y
end

function Rect:getMax()
    return Vector2.new(self.x + self.width, self.y + self.height)
end

function Rect:setMax(max)
    self.x = max.x - self.width
    self.y = max.y - self.height
end

function Rect:getSize()
    return Vector2.new(self.width, self.height)
end

function Rect:setSize(size)
    self.width = size.x
    self.height = size.y
end

function Rect:getXMin()
    return self.x
end

function Rect:setXMin(xMin)
    local xMax = self.x + self.width
    self.x = xMin
    self.width = xMax - xMin
end

function Rect:getYMin()
    return self.y
end

function Rect:setYMin(yMin)
    local yMax = self.y + self.height
    self.y = yMin
    self.height = yMax - yMin
end

function Rect:getXMax()
    return self.x + self.width
end

function Rect:setXMax(xMax)
    self.width = xMax - self.x
end

function Rect:getYMax()
    return self.y + self.height
end

function Rect:setYMax(yMax)
    self.height = yMax - self.y
end

function Rect:getLeft()
    return self.x
end

function Rect:getRight()
    return self.x + self.width
end

function Rect:getTop()
    return self.y
end

function Rect:getBottom()
    return self.y + self.height
end

function Rect:contains(point)
    return point.x >= self.x and point.x < self.x + self.width and point.y >= self.y and point.y < self.y + self.height
end

function Rect:overlaps(other)
    return other.x + other.width > self.x and other.x < self.x + self.width and other.y + other.height > self.y and other.y < self.y + self.height
end

function Rect.normalizedToPoint(rectangle, normalizedRectCoordinates)
    return Vector2.new(
        math.lerp(rectangle.x, rectangle.x + rectangle.width, normalizedRectCoordinates.x),
        math.lerp(rectangle.y, rectangle.y + rectangle.height, normalizedRectCoordinates.y)
    )
end

function Rect.pointToNormalized(rectangle, point)
    return Vector2.new(
        math.InverseLerp(rectangle.x, rectangle.x + rectangle.width, point.x),
        math.InverseLerp(rectangle.y, rectangle.y + rectangle.height, point.y)
    )
end

function Rect:toTable()
    local r = {}
    r.x = self.x or 0
    r.y = self.y or 0
    r.width = self.width or 0
    r.height = self.height or 0
    return r
end

function Rect.Copy(rect)
    return Rect.new(rect.x, rect.y, rect.width, rect.height)
end


function Rect.__eq(lhs, rhs)
    return lhs.x == rhs.x and lhs.y == rhs.y and lhs.width == rhs.width and lhs.height == rhs.height
end

function Rect:__tostring()
    return string.format("Rect(x:%f, y:%f, width:%f, height:%f)", self.x, self.y, self.width, self.height)
end

