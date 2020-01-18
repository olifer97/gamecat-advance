local cat = {}
local platform = {}
local platforms = {}
local sky = {}
local birds = {}

local library = {}

local gravity = -500
local SCREEN_HEIGHT = 350
local SCREEN_WIDTH = 800

local DELTA = 5

local stateGame = "menu"
local menuRectangle = {}

local small_font = love.graphics.newFont("Pixel UniCode.ttf", 16)
local medium_font = love.graphics.newFont("Pixel UniCode.ttf", 24)
local big_font = love.graphics.newFont("Pixel UniCode.ttf", 32)

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

function updateBirds(birds)
    for i=1,birds.count do
        if(birds[i].x + birds.width < 0) then
            birds[i].screen = birds[i].screen + 1
            if(i==1) then 
                birds[i].x = math.random(birds[birds.count].x + love.graphics.getWidth(), birds[birds.count].x + love.graphics.getWidth() * 1.5)
            else
                local distance = birds[i-1] and birds[i-1].x or 0
                birds[i].x = distance + math.random(250, 500)
            end
            birds[i].speed = birds[i].speed + 20
        end
    end
end

--c.x < b.x + b.w and b.x < c.x + c.w
--c.y < b.y + b.h and b.y < c.y + c.h
function checkCollitions(birds, cat)
    for i=1,birds.count do
        if(cat.x + DELTA < birds[i].x + birds.width - DELTA and birds[i].x + DELTA < cat.x + cat.width - DELTA)then 
            if(cat.y + DELTA < birds[i].y + birds.height - DELTA and birds[i].y + DELTA < cat.y + cat.height - DELTA ) then
                return true
            end
        end
    end
    return false
end

function drawGame()
    red = 135/255
    green = 206/255
    blue = 235/255
    color = { red, green, blue}
    love.graphics.setBackgroundColor( color)

    --points
    love.graphics.setFont(medium_font)
    love.graphics.print(cat.points, 5, 0, 0, 1, 1)

    for i=1,platforms.count do
        local platformX = platforms.x + (i-1) * platforms.width + platforms[i].screen * platforms.count * platforms.width
        love.graphics.draw(platforms.img, platformX, platforms.y, 0 , platforms.scale, platforms.scale)
    end

    for i=1,sky.count do
        local skyX = sky.x + (i-1) * sky.width + sky[i].screen * sky.count * sky.width
        love.graphics.draw(sky.img, skyX, sky.y, 0 , sky.scale, sky.scale)
    end

    for i=1,birds.count do
        love.graphics.draw(birds[i].img,birds[i].activeFrame, birds[i].x, birds[i].y, 0, 2, 2)
    end

    local catX = cat.mirror == -1 and cat.x + cat.width or cat.x
    
    love.graphics.draw(cat.activeFrame, catX, cat.y, 0,cat.mirror * cat.scale,cat.scale)
end

function drawMenu()
    --love.graphics.print("Play with my cats", SCREEN_WIDTH/2 - 50, 10, 0, 2, 2)
    love.graphics.setFont(big_font)
    love.graphics.printf("Play with my cats",0, 10, SCREEN_WIDTH,"center", 0)
    love.graphics.setFont(medium_font)
    love.graphics.rectangle("line", menuRectangle.x, menuRectangle.y, cat.width, cat.height )
    love.graphics.draw(cat.chandler[1], cat.chandler.x, SCREEN_HEIGHT/2, 0,cat.scale, cat.scale)
    love.graphics.printf("Chandler", cat.chandler.x, SCREEN_HEIGHT/2 + 80, cat.width, "center", 0, 1, 1)
    love.graphics.draw(cat.lynch[1], cat.lynch.x, SCREEN_HEIGHT/2, 0, -1 * cat.scale,cat.scale)
    love.graphics.printf("Lynch", cat.lynch.x - cat.width, SCREEN_HEIGHT/2 + 80, cat.width, "center", 0, 1, 1)
    love.graphics.setFont(small_font)
    love.graphics.printf("Press 'Enter' to start", 0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, "center", 0)
end

function drawGameOver()
    red = 0/255
    green = 0/255
    blue = 0/255
    color = { red, green, blue}
    love.graphics.setBackgroundColor( color)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(big_font)
    love.graphics.printf("GAME OVER", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, "center")
    love.graphics.setFont(medium_font)
    love.graphics.printf(cat.points, 0, SCREEN_HEIGHT/2 + 50, SCREEN_WIDTH, "center")
    love.graphics.setFont(small_font)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("Press 'Space' to restart", 0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, "center", 0)
end

function updateGame(dt)
    if(checkCollitions(birds, cat)) then 
        stateGame = "gameover"
    else
        if(stateGame == "game") then cat.points = math.ceil(cat.points + (50 * dt)) end
    end

    platforms.x = platforms.x - (platforms.speed * dt)
    sky.x = sky.x - (sky.speed * dt)

    for i=1,birds.count do
        birds[i].x = birds[i].x - (birds[i].speed * dt)
        updateBirdFrame(birds[i], birds[i].frames)
    end

    if(cat.y_velocity == 0)then cat.x = cat.x - (platforms.speed * dt) end

    updateBackground(platforms)
    updateBackground(sky)
    updateBirds(birds)
    

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

function updateMenu()
    if love.keyboard.isDown('left') then 
        menuRectangle.x = cat.chandler.x --chandler
        cat.img = cat.chandler
        cat.activeFrame = cat.img[cat.currentFrame]

    elseif love.keyboard.isDown('right') then
        menuRectangle.x = cat.lynch.x - cat.width --lynch
        cat.img = cat.lynch
        cat.activeFrame = cat.img[cat.currentFrame]

    elseif love.keyboard.isDown('return') then
        stateGame = "game"
    end
end

function initializeGame()
    for i=1,birds.count do
        local randomColor = math.random(0,1)
        birds[i] = {}
        birds[i].frames = randomColor == 0 and birds.blueframes or birds.purpleframes
        birds[i].img = randomColor == 0 and birds.blueImg or birds.purpleImg
        local distance = birds[i-1] and birds[i-1].x or 0
        birds[i].x = distance + math.random(250, 500)
        --birds[i].y = SCREEN_HEIGHT - math.random(100,250)
        birds[i].y = SCREEN_HEIGHT - 90
        birds[i].currentFrame = math.random(1,4)
        birds[i].activeFrame = birds[i].frames[birds[i].currentFrame]
        birds[i].screen = 1
        birds[i].speed = 100 
    end

    cat.x = 60;
    cat.y = SCREEN_HEIGHT - 120;
    cat.img = cat.chandler
    cat.ground = cat.y
    cat.y_velocity = 0
    cat.currentFrame = 1
    cat.activeFrame = cat.img[cat.currentFrame]
    cat.mirror = 1
    cat.points = 0
end

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("My Cats")

    menuRectangle.x = SCREEN_WIDTH/2 - 150 --chandler
    menuRectangle.y = SCREEN_HEIGHT/2

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
    end
    sky.img = love.graphics.newImage("clouds.png")
    sky.width = sky.img:getWidth() * sky.scale

    --birds
    birds.count = 10
    birds.width = 22
    birds.height = 10
    --blue
    birds.blueImg = love.graphics.newImage("bird-blue.png")
    birds.blueframes = {}
    birds.blueframes[1] = love.graphics.newQuad(0,0,22,16,birds.blueImg:getDimensions())
    birds.blueframes[2] = love.graphics.newQuad(22,0,22,16,birds.blueImg:getDimensions())
    birds.blueframes[3] = love.graphics.newQuad(45,0,22,16,birds.blueImg:getDimensions())
    birds.blueframes[4] = love.graphics.newQuad(69,0,22,16,birds.blueImg:getDimensions())
    --purple
    birds.purpleImg = love.graphics.newImage("bird-purple.png")
    birds.purpleframes = {}
    birds.purpleframes[1] = love.graphics.newQuad(0,0,22,16,birds.purpleImg:getDimensions())
    birds.purpleframes[2] = love.graphics.newQuad(22,0,22,16,birds.purpleImg:getDimensions())
    birds.purpleframes[3] = love.graphics.newQuad(45,0,22,16,birds.purpleImg:getDimensions())
    birds.purpleframes[4] = love.graphics.newQuad(69,0,22,16,birds.purpleImg:getDimensions())

    --starting point cat
    cat.chandler = {}
    cat.chandler[1] = love.graphics.newImage("cat-frame-0.png")
    cat.chandler[2] = love.graphics.newImage("cat-frame-1.png")
    cat.chandler[3] = love.graphics.newImage("cat-frame-2.png")
    cat.chandler[4] = love.graphics.newImage("cat-frame-1.png")
    cat.chandler.x = SCREEN_WIDTH/2 - 150

    cat.lynch = {}
    cat.lynch[1] = love.graphics.newImage("cat-grey-frame-0.png")
    cat.lynch[2] = love.graphics.newImage("cat-grey-frame-1.png")
    cat.lynch[3] = love.graphics.newImage("cat-grey-frame-2.png")
    cat.lynch[4] = love.graphics.newImage("cat-grey-frame-1.png")
    cat.lynch.x = SCREEN_WIDTH/2 + 150

    cat.jump_height = -250
    cat.speed = 120
    cat.scale = 0.7
    cat.width = cat.chandler[1]:getWidth() * cat.scale
    cat.height = cat.chandler[1]:getHeight() * cat.scale

    initializeGame()
end

function love.draw()
    if(stateGame == "menu") then 
        drawMenu()
    elseif(stateGame == "game") then 
        drawGame()
    else
        drawGameOver()
    end
end

local elapsedTime = 0
function love.update(dt)
    elapsedTime = elapsedTime + dt
    if(stateGame == "game") then
        updateGame(dt)    

    elseif( stateGame == "menu") then
        updateMenu()
    else
        if love.keyboard.isDown('space') then
            stateGame = "menu"
            initializeGame()
        end
    end   
end
