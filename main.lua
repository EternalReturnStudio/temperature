-- require("lib/lovedebug")
flux = require("lib/flux")

-- =============================================================
-- Variables

res = {
    dir = "assets/",
    imgQueue = {},
    bgmQueue = {},
    sfxQueue = {},
    fntQueue = {},
    img = {},
    bgm = {},
    sfx = {},
    fnt = {}
}

button = {
    play = {
        name = "play",
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    },
    exit = {
        name = "exit",
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        up = nil,
        down = nil,
        wasDown = false,
        isDown = false,
        justPressed = false
    }
}

global = {
    debug = true,
    borderless = false,
    width = 640,
    height = 360,
    screenWidth = 0,
    screenHeight = 0,
    hFullscreenScale = 1,
    vFullscreenScale = 1,
    scaledFullscreen = false,
    hScaleBefore = 1,
    vScaleBefore = 1,
    volume = 1,
    inGame = false,
    inCredits = false,
    easing = "backout"
}

settings = {
    hScale = 1,
    vScale = 1,
    fullscreen = false,
    sound = true
}

transition = {
    red = 32,
    green = 32,
    blue = 32,
    alpha = 0
}

timers = {
    time = 1.0,
    inTransition = false,
    toGame = false,
    toMenu = false,
    toCredits = false,
    exit = false,
    toGameTime = 0,
    toMenuTime = 0,
    toCreditsTime = 0,
    exitTime = 0
}

-- =============================================================
-- Love2D main functions

function love.load()
    -- load settings
    if not love.filesystem.exists("data.bin") then love.filesystem.write("data.bin", table.show(settings, "settings")) end
    settingsChunk = love.filesystem.load("data.bin")
    settingsChunk()

    -- setup window
    love.window.setMode(0, 0, { fullscreen = false })
    global.screenWidth = love.graphics.getWidth()
    global.screenHeight = love.graphics.getHeight()

    if global.scaledFullscreen then
        -- NOTE: posible escalado entero
        while global.width * (global.hFullscreenScale + 1) < global.screenWidth and global.height * (global.vFullscreenScale + 1) < global.screenHeight do
            global.hFullscreenScale = global.hFullscreenScale + 1
            global.vFullscreenScale = global.vFullscreenScale + 1
        end
    else
        global.hFullscreenScale = global.screenWidth / global.width
        global.vFullscreenScale = global.screenHeight / global.height
    end

    love.graphics.setBackgroundColor(88, 88, 88)
    if settings.fullscreen then
        global.hScaleBefore = settings.hScale
        global.vScaleBefore = settings.vScale
        settings.hScale = global.hFullscreenScale
        settings.vScale = global.vFullscreenScale
    end

    love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    math.randomseed(os.time())

    -- load resources
    loadImg("menu", "menu.png")
    loadImg("credits", "credits.png")
    loadImg("game", "game.png")
    loadImg("btnPlayUp", "btn-play-up.png")
    loadImg("btnPlayDown", "btn-play-down.png")

    loadSfx("select_0", "select_0.ogg")
    loadSfx("select_1", "select_1.ogg")
    loadSfx("select_2", "select_2.ogg")
    loadSfx("select_3", "select_3.ogg")

    loadBgm("music", "music.mp3")
    loadSfx("yaay", "yaay.ogg")

    loadFont("font", "smart.ttf", 32)
    loadRes()

    -- setup objects
    -- button.play.up = res.img.playUp
    -- button.play.down = res.img.playDown
    -- button.play.width = button.play.up:getWidth()
    -- button.play.height = button.play.up:getHeight()
    -- button.play.x = global.width / 2 - (button.play.up:getWidth() / 2)
    -- button.play.y = global.height * 3 / 4 - (button.play.down:getHeight() / 2) - 10
    -- button.exit.up = res.img.exitUp
    -- button.exit.down = res.img.exitDown
    -- button.exit.width = button.exit.up:getWidth()
    -- button.exit.height = button.exit.up:getHeight()

    button.play.up = res.img.btnPlayUp
    button.play.down = res.img.btnPlayDown
    button.play.width = button.play.up:getWidth()
    button.play.height = button.play.up:getHeight()
    button.play.x = 32
    button.play.y = 280

    love.graphics.setFont(res.fnt.font)
    if settings.sound then res.bgm.music:play() end
end

-- -------------------------------------------------------------

function love.update(dt)
    flux.update(dt)

    if not timers.inTransition then
        if global.inGame then
            updateGame(dt)
        elseif global.inCredits then
            updateCredits(dt)
        else
            updateMenu(dt)
        end
    end

    updateTimers(dt)
end

-- -------------------------------------------------------------

function updateGame(dt)
    button.back.justPressed = false
    if button.back.wasDown and not button.back.isDown then
        button.back.isDown = false
        button.back.wasDown = false
        button.back.justPressed = true
        timers.inTransition = true
        timers.toMenu = true
        startTransition()
    end
    button.back.wasDown = button.back.isDown

    if button.back.justPressed then res.sfx.select_1:play() end
end

-- -------------------------------------------------------------

function updateMenu(dt)
    button.play.justPressed = false
    if button.play.wasDown and not button.play.isDown then
        button.play.isDown = false
        button.play.wasDown = false
        button.play.justPressed = true
        timers.inTransition = true
        timers.toGame = true
        startTransition()
    end
    button.play.wasDown = button.play.isDown

    button.exit.justPressed = false
    if button.exit.wasDown and not button.exit.isDown then
        button.exit.isDown = false
        button.exit.wasDown = false
        button.exit.justPressed = true
        timers.inTransition = true
        timers.exit = true
        exitTransition()
    end
    button.exit.wasDown = button.exit.isDown

    if button.play.justPressed then res.sfx.select_2:play() end
    if button.exit.justPressed then res.sfx.select_0:play() end
end

-- -------------------------------------------------------------

function updateCredits(dt)
    button.back.justPressed = false
    if button.back.wasDown and not button.back.isDown then
        button.back.isDown = false
        button.back.wasDown = false
        button.back.justPressed = true
        timers.inTransition = true
        timers.toMenu = true
        startTransition()
    end
    button.back.wasDown = button.back.isDown

    if button.back.justPressed then res.sfx.select_1:play() end
end

-- -------------------------------------------------------------

function updateTimers(dt)
    if timers.exit then
        res.bgm.music:setVolume(global.volume)
        timers.exitTime = timers.exitTime + dt
        if timers.exitTime > timers.time then
            timers.exitTime = 0
            timers.exit = false
            timers.inTransition = false
            love.event.push("quit")
        end
    elseif timers.toGame then
        timers.toGameTime = timers.toGameTime + dt

        if timers.toGameTime > timers.time / 2 then
            global.inGame = true
        end

        if timers.toGameTime > timers.time then
            timers.toGameTime = 0
            timers.toGame = false
            timers.inTransition = false
            resetLevel()
            timers.resetting = true
            resetTransition()
        end
    elseif timers.toMenu then
        timers.toMenuTime = timers.toMenuTime + dt

        if timers.toMenuTime > timers.time / 2 then
            global.inGame = false
            global.inCredits = false
        end

        if timers.toMenuTime > timers.time then
            timers.toMenuTime = 0
            timers.toMenu = false
            timers.inTransition = false
        end
    elseif timers.toCredits then
        timers.toCreditsTime = timers.toCreditsTime + dt

        if timers.toCreditsTime > timers.time / 2 then
            global.inCredits = true
        end

        if timers.toCreditsTime > timers.time then
            timers.toCreditsTime = 0
            timers.toCredits = false
            timers.inTransition = false
        end
    end
end

-- -------------------------------------------------------------

function love.draw(dt)
    if global.inGame then
        drawGame(dt)
    elseif global.inCredits then
        drawCredits(dt)
    else
        drawMenu(dt)
    end

    if timers.inTransition then
        drawTransition()
    end

    if global.debug then
        local yy = 5
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print("::Debug::", 5, yy)
        yy = yy + 25
        love.graphics.print("FPS: " .. love.timer.getFPS(), 5, yy)
        yy = yy + 25
        love.graphics.print("play.isDown: " .. tostring(button.play.isDown), 5, yy)
        yy = yy + 25
        love.graphics.print("mouse on button: " .. tostring(boxHit(love.mouse.getX(), love.mouse.getY(), button.play.x * settings.hScale, button.play.y * settings.vScale, button.play.width * settings.hScale, button.play.height * settings.vScale)), 5, yy)
    end
end

-- -------------------------------------------------------------

num = 25
frames = 180
theta = 0
function drawMenu(dt)
    love.graphics.draw(res.img.menu, 0, 0, 0, settings.hScale, settings.vScale)

    local hUnit = love.graphics.getWidth() / num
    local vUnit = love.graphics.getHeight() / num
    for y=0,num do
        for x=0,num do
            local distance = math.sqrt(math.pow((love.graphics.getWidth() / 2) - (x * hUnit), 2) + math.pow((love.graphics.getHeight() / 2) - (y * vUnit), 2))
            local offset = map(distance, 0, math.sqrt(math.pow(love.graphics.getWidth() / 2, 2) + math.pow(love.graphics.getHeight() / 2, 2)), 0, math.pi * 2)
            local sz = map(math.sin(theta + offset), -1, 1, hUnit * 0.2, vUnit * 0.1)
            local angle = math.atan2(y * vUnit - love.graphics.getHeight() / 2, x * hUnit - love.graphics.getWidth() / 2)

            love.graphics.push()
            love.graphics.translate(x * hUnit, y * vUnit)
            love.graphics.rotate(angle)
            love.graphics.ellipse("fill", map(math.sin(theta + offset), -1, 1, 0, 50), 0, sz / 2, sz / 2)
            love.graphics.pop()
        end
    end

    theta = theta - (math.pi * 2 / frames)

    drawButton(button.play)
end

-- -------------------------------------------------------------

function drawCredits(dt)
    love.graphics.draw(res.img.credits, 0, 0, 0, settings.hScale, settings.vScale)

    if button.back.isDown then
        love.graphics.draw(button.back.down, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(button.back.up, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end
end

-- -------------------------------------------------------------

function drawGame(dt)
    love.graphics.draw(res.img.game, 0, 0, 0, settings.hScale, settings.vScale)
    drawPaths(dt)
    love.graphics.draw(res.img.board, 0, 0, 0, settings.hScale, settings.vScale)
    drawMoves(dt)
    drawTokens(dt)

    if button.back.isDown then
        love.graphics.draw(button.back.down, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(button.back.up, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end

    if button.again.isDown then
        love.graphics.draw(button.again.down, button.again.x * settings.hScale, button.again.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(button.again.up, button.again.x * settings.hScale, button.again.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end

    love.graphics.setColor(68, 68, 68, 255)
    love.graphics.print("Level " .. settings.level, (57 - (res.fnt.font:getWidth("Level " .. settings.level) / 2)) * settings.hScale, (global.height * 3 / 5) * settings.vScale, 0, settings.hScale, settings.vScale)
    love.graphics.setColor(255, 255, 255, 255)
end

-- -------------------------------------------------------------

function drawButton(b)
    if (b.isDown) then
        love.graphics.draw(b.down, b.x * settings.hScale, b.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(b.up, b.x * settings.hScale, b.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end
end

-- -------------------------------------------------------------

function DEPRECATED_nextLevel()
    love.filesystem.write("data.bin", table.show(settings, "settings"))
    res.sfx.yaay:setVolume(0.5)
    res.sfx.yaay:play()
end

-- -------------------------------------------------------------

function DEPRECATED_resetTransition()
    for i, token in ipairs(tokens) do
        flux.to(token, 1, { x = spots[token.pos].x, y = spots[token.pos].y }):ease(global.easing)
    end
end

function startTransition()
    flux.to(transition, 0.5, { alpha = 255 }):after(transition, 0.5, { alpha = 0 })
end

function exitTransition()
    flux.to(global, 1, { volume = 0 })
    flux.to(transition, 1, { red = 0, green = 0, blue = 0, alpha = 255 })
end

function drawTransition()
    love.graphics.setColor(transition.red, transition.green, transition.blue, transition.alpha)
    love.graphics.rectangle("fill", 0, 0, global.width * settings.hScale, global.height * settings.vScale)
    love.graphics.setColor(255, 255, 255, 255)
end

-- -------------------------------------------------------------

function love.keypressed(k)
    if not timers.toGame and not timers.toMenu then
        -- scale window up
        if k == "+" then
            if not settings.fullscreen and settings.hScale < 5 and settings.vScale < 5 then
                settings.hScale = settings.hScale + 1
                settings.vScale = settings.vScale + 1
                love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
            end
            return
        end

        -- scale window down
        if k == "-" then
            if not settings.fullscreen and settings.hScale > 1 and settings.vScale > 1 then
                settings.hScale = settings.hScale - 1
                settings.vScale = settings.vScale - 1
                love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
            end
            return
        end

        -- toggle fullscreen
        if k == "return" and love.keyboard.isDown("lalt", "ralt", "alt") then
            settings.fullscreen = not settings.fullscreen
            if settings.fullscreen then
                global.hScaleBefore = settings.hScale
                global.vScaleBefore = settings.vScale
                settings.hScale = global.hFullscreenScale
                settings.vScale = global.vFullscreenScale
            else
                settings.hScale = global.hScaleBefore
                settings.vScale = global.vScaleBefore
            end

            love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
        end
    end
end

-- -------------------------------------------------------------

function love.keyreleased(k)
    if not timers.toGame and not timers.toMenu then
        -- quit the game
        if k == "escape" then
            if global.inGame or global.inCredits then
                timers.inTransition = true
                timers.toMenu = true
                startTransition()
                res.sfx.select_1:play()
            else
                res.sfx.select_0:play()
                timers.inTransition = true
                timers.exit = true
                exitTransition()
            end
            return
        end
    end
end

-- -------------------------------------------------------------

function love.mousepressed(x, y, b)
    if global.inGame then
        if b == 1 then
            if not timers.toMenu and boxHit(x, y, button.back.x * settings.hScale, button.back.y * settings.vScale, button.back.width * settings.hScale, button.back.height * settings.vScale) then
                button.back.isDown = true
            end
        end
    elseif global.inCredits then
        if b == 1 then
            if not timers.toMenu and boxHit(x, y, button.back.x * settings.hScale, button.back.y * settings.vScale, button.back.width * settings.hScale, button.back.height * settings.vScale) then
                button.back.isDown = true
            end
        end
    else
        if b == 1 then
            if not timers.toGame and boxHit(x, y, button.play.x * settings.hScale, button.play.y * settings.vScale, button.play.width * settings.hScale, button.play.height * settings.vScale) then
                button.play.isDown = true
                res.sfx.select_0:play()
            end

            -- if not timers.toCredits and boxHit(x, y, button.info.x * settings.hScale, button.info.y * settings.vScale, button.info.width * settings.hScale, button.info.height * settings.vScale) then
            --     button.info.isDown = true
            -- end

            -- if not timers.exit and boxHit(x, y, button.exit.x * settings.hScale, button.exit.y * settings.vScale, button.exit.width * settings.hScale, button.exit.height * settings.vScale) then
            --     button.exit.isDown = true
            -- end
        end
    end
end

-- -------------------------------------------------------------

function love.mousereleased(x, y, b)
    if global.inGame then
        if b == 1 then
            if not timers.toMenu and button.back.isDown then button.back.isDown = false end
            if not timers.reset and button.again.isDown then button.again.isDown = false end
        end
    elseif global.inCredits then
        if b == 1 then
            if not timers.toMenu and button.back.isDown then button.back.isDown = false end
        end
    else
        if b == 1 then
            if not timers.toGame and button.play.isDown then button.play.isDown = false end
            -- if not timers.toCredits and button.info.isDown then button.info.isDown = false end
            -- if not timers.exit and button.exit.isDown then button.exit.isDown = false end
        end
    end
end

-- -------------------------------------------------------------

function love.mousemoved(x, y, dx, dy) end

-- -------------------------------------------------------------

function love.quit()
    if settings.fullscreen then
        settings.hScale = global.hScaleBefore
        settings.vScale = global.vScaleBefore
    end
    love.filesystem.write("data.bin", table.show(settings, "settings"))
end

-- =============================================================
-- Is mouse on box ?

function boxHit(mx, my, x, y, w, h)
    return mx > x and mx < x + w and my > y and my < y + h
end

-- =============================================================
-- Assets management

function loadFont(name, src, size)
    res.fntQueue[name] = { src, size }
end

-- -------------------------------------------------------------

function loadImg(name, src)
    res.imgQueue[name] = src
end

-- -------------------------------------------------------------

function loadBgm(name, src)
    res.bgmQueue[name] = src
end

-- -------------------------------------------------------------

function loadSfx(name, src)
    res.sfxQueue[name] = src
end

-- -------------------------------------------------------------

function loadRes(threaded)
    for name, pair in pairs(res.fntQueue) do
        res.fnt[name] = love.graphics.newFont(res.dir .. "fnt/" .. pair[1], pair[2])
        res.fntQueue[name] = nil
    end

    for name, src in pairs(res.imgQueue) do
        res.img[name] = love.graphics.newImage(res.dir .. "img/" .. src)
        res.imgQueue[name] = nil
    end

    for name, src in pairs(res.bgmQueue) do
        res.bgm[name] = love.audio.newSource(res.dir .. "bgm/" .. src)
        res.bgm[name]:setLooping(true)
        res.bgmQueue[name] = nil
    end

    for name, src in pairs(res.sfxQueue) do
        res.sfx[name] = love.audio.newSource(res.dir .. "sfx/" .. src)
        res.sfx[name]:setLooping(false)
        res.sfxQueue[name] = nil
    end
end

-- =============================================================
-- Map

function map(value, istart, istop, ostart, ostop)
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
end

-- =============================================================
-- Table contains

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- =============================================================
-- Table to string

function table.show(t, name, indent)
    local cart -- a container
    local autoref -- for self references

    --[[ counts the number of elements in a table
    local function tablecount(t)
        local n = 0
        for _, _ in pairs(t) do n = n+1 end
        return n
    end
    ]]

    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize(o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return string.format("%q", so .. ", C function")
            else
                -- the information is defined through lines
                return string.format("%q", so .. ", defined in (" .. info.linedefined .. "-" .. info.lastlinedefined .. ")" .. info.source)
            end
        elseif type(o) == "number" or type(o) == "boolean" then
            return so
        else
            return string.format("%q", so)
        end
    end

    local function addtocart(value, name, indent, saved, field)
        indent = indent or ""
        saved = saved or {}
        field = field or name

        cart = cart .. indent .. field

        if type(value) ~= "table" then
            cart = cart .. " = " .. basicSerialize(value) .. ";\n"
        else
            if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value] .. " (self reference)\n"
                autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
            else
                saved[value] = name
                --if tablecount(value) == 0 then
                if isemptytable(value) then
                    cart = cart .. " = {};\n"
                else
                    cart = cart .. " = {\n"
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = string.format("%s[%s]", name, k)
                        field = string.format("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. "   ", saved, field)
                    end
                    cart = cart .. indent .. "};\n"
                end
            end
        end
    end

    name = name or "__unnamed__"

    if type(t) ~= "table" then
        return name .. " = " .. basicSerialize(t)
    end

    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end
