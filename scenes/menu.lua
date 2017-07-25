num = 25
frames = 180
theta = 0

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
