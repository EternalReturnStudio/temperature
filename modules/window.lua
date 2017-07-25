function setupWindow()
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
end

function scaleUpWindow()
    if not settings.fullscreen and settings.hScale < 5 and settings.vScale < 5 then
        settings.hScale = settings.hScale + 1
        settings.vScale = settings.vScale + 1
        love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
    end
end

function scaleDownWindow()
    if not settings.fullscreen and settings.hScale > 1 and settings.vScale > 1 then
        settings.hScale = settings.hScale - 1
        settings.vScale = settings.vScale - 1
        love.window.setMode(global.width * settings.hScale, global.height * settings.vScale, { fullscreen = settings.fullscreen, borderless = global.borderless })
    end
end

function toggleFullscreen()
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

function storeWindowScale()
    if settings.fullscreen then
        settings.hScale = global.hScaleBefore
        settings.vScale = global.vScaleBefore
    end
end
