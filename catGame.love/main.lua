local cat = {}
local platform = {}
local platforms = {}

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

function updatePlatforms()
    for i=1,platforms.count do
        local platformX = platforms.x + (i-1) * platforms.width + platforms[i].screen * platforms.count * platforms.width
        if(platformX + platforms.width < 0) then platforms[i].screen = platforms[i].screen + 1 end
    end
end

function love.load()
    love.window.setMode(800, 400, {resizable=false, vsync=false, minwidth=400, minheight=300})

    --platforms
    platforms.img = love.graphics.newImage("platform_outside.png")
    platforms.scale = 0.4
    platforms.count = 4
    platforms.width = platforms.img:getWidth() * platforms.scale
    platforms.y = 320
    platforms.x = 0
    platforms.speed = 80
    for i=1,platforms.count do 
        platforms[i] = {}
        platforms[i].screen = 0 
    end


    --starting point cat
    cat.x = 60;
    cat.y = 280;
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
    cat.speed = 120
    cat.scale = 0.7
    cat.width = cat.img[1]:getWidth() * cat.scale

    --library
    --library.x = love.graphics.getWidth()
    --library.y = 133
    --library.speed = 80
    --library.img = love.graphics.newImage("library.png")
end

function love.draw()
    --love.graphics.draw(library.img, library.x, library.y, 0 , 0.8,0.8)

    --background color
    red = 135/255
    green = 206/255
    blue = 235/255
    color = { red, green, blue}
    love.graphics.setBackgroundColor( color)

    for i=1,platforms.count do
        local platformX = platforms.x + (i-1) * platforms.width + platforms[i].screen * platforms.count * platforms.width
        love.graphics.draw(platforms.img, platformX, platforms.y, 0 , platforms.scale, platforms.scale)
    end

    local catX = cat.mirror == -1 and cat.x + cat.width or cat.x
    
    love.graphics.draw(cat.activeFrame, catX, cat.y, 0,cat.mirror * cat.scale,cat.scale)
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt

    --library.x = library.x - (library.speed * dt)
    platforms.x = platforms.x - (platforms.speed * dt)
    cat.x = cat.x - (platforms.speed * dt)

    updatePlatforms()

    if(cat.x < 0) then
        cat.x = cat.x + (platforms.speed * dt)
        updateCatframes()
    end

    if love.keyboard.isDown('right') then 
        cat.x = cat.x + (cat.speed * dt)
        --if(elapsedTime > 0.1) then
        cat.mirror = 1
        updateCatframes()
        elapsedTime = 0
        --end
        
	elseif love.keyboard.isDown('left') then
        cat.x = cat.x - (cat.speed * dt) + (platforms.speed * dt)
        if(cat.x < 0) then
            cat.x = cat.x + (cat.speed * dt)
        end
        --if(elapsedTime > 0.1) then
        cat.mirror = -1
        updateCatframes()
        elapsedTime = 0
    end
    
    --salto
    if love.keyboard.isDown('space') then
        if cat.y_velocity == 0 then
            cat.y_velocity = cat.jump_height
        end
    end

    --chequeo si me fui de rango en algunda direccion y corrijo
    if(cat.x + cat.width > love.graphics.getWidth()) then
        cat.x = cat.x - (cat.speed * dt)
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