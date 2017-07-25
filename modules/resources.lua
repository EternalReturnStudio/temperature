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

function loadFont(name, src, size)
    res.fntQueue[name] = { src, size }
end

function loadImg(name, src)
    res.imgQueue[name] = src
end

function loadBgm(name, src)
    res.bgmQueue[name] = src
end

function loadSfx(name, src)
    res.sfxQueue[name] = src
end

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
