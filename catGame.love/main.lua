local cat = {}
local platform = {}

local library = {}

local gravity = -500

function updateCatframes()
    if(cat.currentFrame < 3) then
        if (cat.y_velocity == 0) then
            cat.currentFrame = cat.currentFrame + 1
        else
            cat.currentFrame = 2
        end
    else
        cat.currentFrame = 1
    end
    cat.activeFrame = cat.img[cat.currentFrame]
end

function love.load()

    --basic platform
     -- This is the height and the width of the platform.
	platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
	platform.height = love.graphics.getHeight()  -- This makes the platform as tall as the whole game window.
 
        -- This is the coordinates where the platform will be rendered.
	platform.x = 0                              -- This starts drawing the platform at the left edge of the game window.
	platform.y = 350            -- This starts drawing the platform at the very middle of the game window

    --starting point cat
    cat.x = 60;
    cat.y = 290;
    cat.img = {}
    cat.img[1] = love.graphics.newImage("cat-frame-0.png")
    cat.img[2] = love.graphics.newImage("cat-frame-1.png")
    cat.img[3] = love.graphics.newImage("cat-frame-2.png")
    cat.ground = cat.y
    cat.y_velocity = 0
    cat.jump_height = -250
    cat.currentFrame = 1
    cat.activeFrame = cat.img[cat.currentFrame]
    cat.mirror = 1
    cat.speed = 100
    cat.width = cat.img[1]:getWidth() * 3

    --library
    library.x = love.graphics.getWidth()
    library.y = 133
    library.speed = 80
    library.img = love.graphics.newImage("library.png")
end

function love.draw()
    love.graphics.draw(library.img, library.x, library.y, 0 , 0.8,0.8)
    love.graphics.setColor(1, 1, 1)        -- This sets the platform color to white.
     -- The platform will now be drawn as a white rectangle while taking in the variables we declared above.
    love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
    

    love.graphics.draw(cat.activeFrame,cat.x,cat.y,0,cat.mirror * 3,3)
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt

    library.x = library.x - (library.speed * dt)

    if love.keyboard.isDown('right') then 
        cat.x = cat.x + (cat.speed * dt)
        if(cat.x + cat.width > love.graphics.getWidth()) then
            cat.x = cat.x - (cat.speed * dt)
        end
        --if(elapsedTime > 0.1) then
        cat.mirror = 1
        updateCatframes()
        elapsedTime = 0
        --end
        
	elseif love.keyboard.isDown('left') then
        cat.x = cat.x - (cat.speed * dt)
        if(cat.x - cat.width < 0) then
            cat.x = cat.x + (cat.speed * dt)
        end
        --if(elapsedTime > 0.1) then
        cat.mirror = -1
        updateCatframes()
        elapsedTime = 0
    end
    
     -- This is in charge of cat jumping.
    if love.keyboard.isDown('space') then                     -- Whenever the cat presses or holds down the Spacebar:
        -- The game checks if the cat is on the ground. Remember that when the cat is on the ground, Y-Axis Velocity = 0.
        if cat.y_velocity == 0 then
            cat.y_velocity = cat.jump_height    -- The cat's Y-Axis Velocity is set to it's Jump Height.
        end
    end

    if cat.y_velocity ~= 0 then
		cat.y = cat.y + cat.y_velocity * dt
		cat.y_velocity = cat.y_velocity - gravity * dt
	end
 
	if cat.y > cat.ground then
		cat.y_velocity = 0
    	cat.y = cat.ground
	end
end