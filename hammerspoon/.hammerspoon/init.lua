function center()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = (max.w / 2) - (f.w / 2)
    f.y = (max.h / 2) - (f.h / 2) + 20
    win:setFrame(f)
end

function resize(w, h)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local resized = false
    local moved = false
    local max = screen:frame()

    if (f.x + w) > max.w then
        f.x = f.x - ((f.x + w) - max.w )
        moved = true
    end

    if (f.y + h) > max.h then
        f.y = f.y - ((f.y + h) - max.h )
        moved = true
    end

    if moved then
        win:setFrame(f)
    end

    if f.w < w or f.w > w then
        f.w = w
        resized = true
    end

    if f.h < h or f.h > h then
        f.h = h
        resized = true
    end

    if resized then
        win:setFrame(f)
    end
end

-- bindings
hs.hotkey.bind({"cmd", "alt"}, "delete", function() center() end)
hs.hotkey.bind({"cmd", "alt"}, "[", function() resize(1200, 800) end)
hs.hotkey.bind({"cmd", "alt"}, "]", function() resize(1400, 900) end)

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon Config Loaded")