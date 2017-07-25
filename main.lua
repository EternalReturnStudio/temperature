-- require("lib/lovedebug")
flux = require("lib/flux")

require("modules/resources")
require("modules/utils")
require("modules/transitions")
require("modules/window")
require("modules/buttons")

require("scenes/menu")
require("scenes/game")
require("scenes/credits")

-- =============================================================
-- Variables

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

-- =============================================================
-- Love2D main functions

function love.load()
    -- load settings
    if not love.filesystem.exists("data.bin") then love.filesystem.write("data.bin", table.show(settings, "settings")) end
    settingsChunk = love.filesystem.load("data.bin")
    settingsChunk()

    setupWindow()
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

function love.keypressed(k)
    if not timers.inTransition then
        if k == "+" then scaleUpWindow() return end
        if k == "-" then scaleDownWindow() return end
        if k == "return" and love.keyboard.isDown("lalt", "ralt", "alt") then
            toggleFullscreen()
            return
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
    buttonPressed(x, y, b)
end

-- -------------------------------------------------------------

function love.mousereleased(x, y, b)
    buttonReleased(x, y, b)
end

-- -------------------------------------------------------------

function love.mousemoved(x, y, dx, dy) end

-- -------------------------------------------------------------

function love.quit()
    storeWindowScale()
    love.filesystem.write("data.bin", table.show(settings, "settings"))
end
