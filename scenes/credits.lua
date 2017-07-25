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

function drawCredits(dt)
    love.graphics.draw(res.img.credits, 0, 0, 0, settings.hScale, settings.vScale)

    if button.back.isDown then
        love.graphics.draw(button.back.down, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(button.back.up, button.back.x * settings.hScale, button.back.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end
end
