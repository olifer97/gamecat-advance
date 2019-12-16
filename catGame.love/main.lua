local cat = {}


function love.load()

    --starting point
    cat.x = 50;
    cat.y = 350;
    cat.img = {}
    cat.img[1] = love.graphics.newImage("cat-frame-0.png")
    cat.img[2] = love.graphics.newImage("cat-frame-1.png")
    cat.img[3] = love.graphics.newImage("cat-frame-2.png")
    cat.currentFrame = 1
    cat.activeFrame = cat.img[cat.currentFrame]
    cat.mirror = 1
    cat.speed = 100
end

function love.draw()
    love.graphics.draw(cat.activeFrame,cat.x,cat.y,0,cat.mirror * 3,3)
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt

    if love.keyboard.isDown('right') then 
        cat.x = cat.x + (cat.speed * dt)
        --if(elapsedTime > 0.1) then
        cat.mirror = 1
        if(cat.currentFrame < 3) then
            cat.currentFrame = cat.currentFrame + 1
        else
        cat.currentFrame = 1
        end
        cat.activeFrame = cat.img[cat.currentFrame]
        elapsedTime = 0
        --end
        
	elseif love.keyboard.isDown('left') then
        cat.x = cat.x - (cat.speed * dt)
        --if(elapsedTime > 0.1) then
        cat.mirror = -1
        if(cat.currentFrame < 3) then
            cat.currentFrame = cat.currentFrame + 1
        else
        cat.currentFrame = 1
        end
        cat.activeFrame = cat.img[cat.currentFrame]
        elapsedTime = 0
	end
end