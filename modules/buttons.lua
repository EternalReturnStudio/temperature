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

function drawButton(b)
    if (b.isDown) then
        love.graphics.draw(b.down, b.x * settings.hScale, b.y * settings.vScale, 0, settings.hScale, settings.vScale)
    else
        love.graphics.draw(b.up, b.x * settings.hScale, b.y * settings.vScale, 0, settings.hScale, settings.vScale)
    end
end

function buttonPressed(x, y, b)
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

function buttonReleased(x, y, b)
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
