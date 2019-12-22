local cat = {}
local platform = {}
local platforms = {}
local sky = {}
local birdsPurple = {}

local library = {}

local gravity = -500
local SCREEN_HEIGHT = 350
local SCREEN_WIDTH = 800

function updateCatframes()
    if(cat.currentFrame < 4) then
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

function updateBirdFrame(bird, frames)
    if(bird.currentFrame < 4) then
        bird.currentFrame = bird.currentFrame + 1
    else
        bird.currentFrame = 1
    end
    bird.activeFrame = frames[bird.currentFrame]
end

function updateBackground(object)
    for i=1,object.count do
        local objectX = object.x + (i-1) * object.width + object[i].screen * object.count * object.width
        if(objectX + object.width < 0) then object[i].screen = object[i].screen + 1 end
    end
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {resizable=false, vsync=false, minwidth=400, minheight=300})

    --platforms
    platforms.img = love.graphics.newImage("platform_outside.png")
    platforms.scale = 0.4
    platforms.count = 4
    platforms.width = platforms.img:getWidth() * platforms.scale
    platforms.y = SCREEN_HEIGHT - 80
    platforms.x = 0
    platforms.speed = 80
    for i=1,platforms.count do 
        platforms[i] = {}
        platforms[i].screen = 0 
    end

    --sky
    sky.x = 0
    sky.y = 30
    sky.speed = 50
    sky.count = 3
    sky.scale = 0.4
    for i=1,sky.count do 
        sky[i] = {}
        sky[i].screen = 0 
        --sky[i].img = 
    end
    sky.img = love.graphics.newImage("clouds.png")
    sky.width = sky.img:getWidth() * sky.scale

    --birds
    birdsPurple.count = 10
    birdsPurple.speed = 40
    birdsPurple.img = love.graphics.newImage("bird-purple.png")
    birdsPurple.frames = {}
    birdsPurple.frames[1] = love.graphics.newQuad(0,0,24,16,birdsPurple.img:getDimensions())
    birdsPurple.frames[2] = love.graphics.newQuad(24,0,24,16,birdsPurple.img:getDimensions())
    birdsPurple.frames[3] = love.graphics.newQuad(48,0,24,16,birdsPurple.img:getDimensions())
    birdsPurple.frames[4] = love.graphics.newQuad(72,0,24,16,birdsPurple.img:getDimensions())
    for i=1,birdsPurple.count do
        birdsPurple[i] = {}
        local distance = birdsPurple[i-1] and 50 or 0
        birdsPurple[i].x = math.random(love.graphics.getWidth(), love.graphics.getWidth() * 2) + distance
        birdsPurple[i].y = SCREEN_HEIGHT - math.random(200,250)
        birdsPurple[i].currentFrame = math.random(1,4)
        birdsPurple[i].activeFrame = birdsPurple.frames[birdsPurple[i].currentFrame]
    end

    --starting point cat
    cat.x = 60;
    cat.y = SCREEN_HEIGHT - 120;
    cat.img = {}
    cat.img[1] = love.graphics.newImage("cat-frame-0.png")
    cat.img[2] = love.graphics.newImage("cat-frame-1.png")
    cat.img[3] = love.graphics.newImage("cat-frame-2.png")
    cat.img[4] = love.graphics.newImage("cat-frame-1.png")
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
    -- 78,173,245
    red = 135/255
    green = 206/255
    blue = 235/255
    color = { red, green, blue}
    love.graphics.setBackgroundColor( color)

    for i=1,platforms.count do
        local platformX = platforms.x + (i-1) * platforms.width + platforms[i].screen * platforms.count * platforms.width
        love.graphics.draw(platforms.img, platformX, platforms.y, 0 , platforms.scale, platforms.scale)
    end

    for i=1,sky.count do
        local skyX = sky.x + (i-1) * sky.width + sky[i].screen * sky.count * sky.width
        love.graphics.draw(sky.img, skyX, sky.y, 0 , sky.scale, sky.scale)
    end

    for i=1,birdsPurple.count do
        love.graphics.draw(birdsPurple.img,birdsPurple[i].activeFrame, birdsPurple[i].x, birdsPurple[i].y, 0, 2, 2)
    end

    local catX = cat.mirror == -1 and cat.x + cat.width or cat.x
    
    love.graphics.draw(cat.activeFrame, catX, cat.y, 0,cat.mirror * cat.scale,cat.scale)
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt

    --library.x = library.x - (library.speed * dt)
    platforms.x = platforms.x - (platforms.speed * dt)
    sky.x = sky.x - (sky.speed * dt)

    for i=1,birdsPurple.count do
        birdsPurple[i].x = birdsPurple[i].x - (birdsPurple.speed * dt)
        updateBirdFrame(birdsPurple[i], birdsPurple.frames)
    end

    if(cat.y_velocity == 0)then cat.x = cat.x - (platforms.speed * dt) end

    updateBackground(platforms)
    updateBackground(sky)
    

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
        cat.x = cat.x - (cat.speed * dt)

        if(cat.y_velocity == 0)then cat.x = cat.x + (platforms.speed * dt) end

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