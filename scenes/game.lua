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

function DEPRECATED_nextLevel()
    love.filesystem.write("data.bin", table.show(settings, "settings"))
    res.sfx.yaay:setVolume(0.5)
    res.sfx.yaay:play()
end
