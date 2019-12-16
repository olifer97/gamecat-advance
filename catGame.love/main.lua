--local imageFile
local frames = {}

local activeFrame
local currentFrame = 1

local catX = 50
local catMirror = 1
local catSpeed = 100

function love.load()
    frames[1] = love.graphics.newImage("cat-frame-0.png")
    frames[2] = love.graphics.newImage("cat-frame-1.png")
    frames[3] = love.graphics.newImage("cat-frame-2.png")
    activeFrame = frames[currentFrame]
end

function love.draw()
    love.graphics.draw(activeFrame,catX,350,0,catMirror * 3,3)
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt

    if love.keyboard.isDown('right') then 
        catX = catX + (catSpeed * dt)
        --if(elapsedTime > 0.1) then
        catMirror = 1
        if(currentFrame < 3) then
            currentFrame = currentFrame + 1
        else
        currentFrame = 1
        end
        activeFrame = frames[currentFrame]
        elapsedTime = 0
        --end
        
	elseif love.keyboard.isDown('left') then
        catX = catX - (catSpeed * dt)
        catMirror = -1

        if(currentFrame < 3) then
            currentFrame = currentFrame + 1
        else
        currentFrame = 1
        end
        activeFrame = frames[currentFrame]
        elapsedTime = 0
	end
end