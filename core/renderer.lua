-- =============================================================================
-- UI RENDERER - Drawing Engine
-- =============================================================================

UIRenderer = {
    active = false,
    components = {},
    debugMode = false,
    frameCount = 0
}

-- =============================================================================
-- RENDERER LIFECYCLE
-- =============================================================================

function UIRenderer.Start()
    if UIRenderer.active then
        print("^3[FD-UI Renderer] Already running^0")
        return
    end

    UIRenderer.active = true
    UIRenderer.StartRenderLoop()

    print("^2[FD-UI Renderer] Started^0")
end

function UIRenderer.Stop()
    UIRenderer.active = false
    print("^3[FD-UI Renderer] Stopped^0")
end

-- =============================================================================
-- MAIN RENDER LOOP
-- =============================================================================

function UIRenderer.StartRenderLoop()
    Citizen.CreateThread(function()
        print("^2[FD-UI Renderer] Render loop started^0")

        while UIRenderer.active do
            UIRenderer.frameCount = UIRenderer.frameCount + 1

            -- Render all visible components
            local rendered = 0

            for id, component in pairs(UI._components) do
                if component and component.visible and component.Render then
                    local success, err = pcall(function()
                        component:Render()
                        rendered = rendered + 1
                    end)

                    if not success then
                        print("^1[FD-UI Renderer] Error rendering " .. id .. ": " .. tostring(err) .. "^0")
                    end
                end
            end

            -- Debug overlay
            if UIRenderer.debugMode then
                UIRenderer.DrawDebugOverlay(rendered)
            end

            Citizen.Wait(0) -- Every frame
        end

        print("^1[FD-UI Renderer] Render loop stopped^0")
    end)
end

-- =============================================================================
-- DRAWING PRIMITIVES
-- =============================================================================

function UIRenderer.DrawRect(x, y, width, height, color)
    DrawRect(
        x + width / 2,
        y + height / 2,
        width,
        height,
        color.r or 255,
        color.g or 255,
        color.b or 255,
        color.a or 255
    )
end

function UIRenderer.DrawBorder(x, y, width, height, color, thickness)
    thickness = thickness or 0.002

    -- Top
    UIRenderer.DrawRect(x + width / 2, y, width, thickness, color)
    -- Bottom
    UIRenderer.DrawRect(x + width / 2, y + height, width, thickness, color)
    -- Left
    UIRenderer.DrawRect(x, y + height / 2, thickness, height, color)
    -- Right
    UIRenderer.DrawRect(x + width, y + height / 2, thickness, height, color)
end

function UIRenderer.DrawText(x, y, text, font, scale, color, align, shadow)
    align = align or 'left'
    shadow = shadow ~= false

    -- Shadow
    if shadow then
        SetTextFont(font or 4)
        SetTextScale(scale or 0.35, scale or 0.35)
        SetTextColour(0, 0, 0, 200)
        SetTextDropshadow(2, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)

        if align == 'center' then
            SetTextCentre(true)
        elseif align == 'right' then
            SetTextRightJustify(true)
            SetTextWrap(0.0, x)
        end

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x + 0.001, y + 0.001)
    end

    -- Actual Text
    SetTextFont(font or 4)
    SetTextScale(scale or 0.35, scale or 0.35)
    SetTextColour(color.r or 255, color.g or 255, color.b or 255, color.a or 255)
    SetTextDropshadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)

    if align == 'center' then
        SetTextCentre(true)
    elseif align == 'right' then
        SetTextRightJustify(true)
        SetTextWrap(0.0, x)
    end

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function UIRenderer.DrawProgressBar(x, y, width, height, percent, colors)
    percent = math.max(0, math.min(100, percent))

    colors = colors or {}
    local bgColor = colors.background or { r = 50, g = 50, b = 50, a = 200 }
    local barColor = colors.fill or UIRenderer.GetProgressColor(percent)

    -- Background
    UIRenderer.DrawRect(x, y, width, height, bgColor)

    -- Fill
    local fillWidth = (width * percent / 100)
    if fillWidth > 0 then
        UIRenderer.DrawRect(x, y, fillWidth, height, barColor)
    end
end

function UIRenderer.GetProgressColor(percent)
    if percent > 70 then
        return { r = 0, g = 255, b = 0, a = 255 } -- Green
    elseif percent > 30 then
        return { r = 255, g = 200, b = 0, a = 255 } -- Yellow
    else
        return { r = 255, g = 50, b = 50, a = 255 } -- Red
    end
end

function UIRenderer.DrawBox(x, y, width, height, bgColor, borderColor)
    -- Background
    UIRenderer.DrawRect(x, y, width, height, bgColor)

    -- Border
    if borderColor then
        UIRenderer.DrawBorder(x, y, width, height, borderColor)
    end
end

-- =============================================================================
-- 3D DRAWING
-- =============================================================================

function UIRenderer.DrawText3D(coords, text, scale, color)
    scale = scale or 0.35
    color = color or { r = 255, g = 255, b = 255, a = 255 }

    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local dist = #(camCoords - coords)
        local scaleFactor = (1 / dist) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        scaleFactor = scaleFactor * fov

        SetTextScale(0.0 * scaleFactor, scale * scaleFactor)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(coords.x, coords.y, coords.z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

function UIRenderer.DrawMarker3D(coords, type, scale, color)
    type = type or 20
    scale = scale or 1.0
    color = color or { r = 255, g = 255, b = 255, a = 100 }

    DrawMarker(
        type,
        coords.x, coords.y, coords.z - 0.98,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale, scale, 0.5,
        color.r, color.g, color.b, color.a,
        false, true, 2, false,
        nil, nil, false
    )
end

-- =============================================================================
-- DEBUG OVERLAY
-- =============================================================================

function UIRenderer.DrawDebugOverlay(renderedCount)
    local y = 0.01
    local lineHeight = 0.02

    UIRenderer.DrawText(0.01, y, "~b~[FD-UI DEBUG]~w~", 4, 0.3, { r = 255, g = 255, b = 255, a = 255 })
    y = y + lineHeight

    UIRenderer.DrawText(0.01, y, "Frame: " .. UIRenderer.frameCount, 4, 0.25, { r = 200, g = 200, b = 200, a = 255 })
    y = y + lineHeight

    UIRenderer.DrawText(0.01, y, "Components: " .. renderedCount .. "/" .. Utils.TableCount(UI._components), 4, 0.25,
        { r = 200, g = 200, b = 200, a = 255 })
    y = y + lineHeight

    -- Component List
    for id, component in pairs(UI._components) do
        local status = component.visible and "~g~VISIBLE~w~" or "~r~HIDDEN~w~"
        UIRenderer.DrawText(0.01, y, "  " .. id .. ": " .. status, 4, 0.22, { r = 200, g = 200, b = 200, a = 255 })
        y = y + lineHeight * 0.8
    end
end

-- =============================================================================
-- UTILITIES
-- =============================================================================

function UIRenderer.ScreenToRelative(x, y)
    -- Convert pixel coords to 0.0-1.0
    local screenX, screenY = GetActiveScreenResolution()
    return x / screenX, y / screenY
end

function UIRenderer.RelativeToScreen(x, y)
    -- Convert 0.0-1.0 to pixel coords
    local screenX, screenY = GetActiveScreenResolution()
    return x * screenX, y * screenY
end

print("^2[FD-UI Renderer] Loaded^0")
