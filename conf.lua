function love.conf(t)
    t.identity = "temperature"
    t.version = "0.10.2"
    t.console = false
    t.accelerometerjoystick = true
    t.externalstorage = false
    t.gammacorrect = false

    t.window.title = "Temperature"
    t.window.icon = "assets/img/icon.png"
    t.window.width = 640
    t.window.height = 480
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.msaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end
