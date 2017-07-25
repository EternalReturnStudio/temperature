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

function DEPRECATED_resetTransition()
    for i, token in ipairs(tokens) do
        flux.to(token, 1, { x = spots[token.pos].x, y = spots[token.pos].y }):ease(global.easing)
    end
end
