-- =============================================================================
-- UI NOTIFICATIONS SYSTEM
-- =============================================================================

UINotifications = {
    active = {},
    nextId = 1,
    defaultDuration = 3000,
    maxVisible = 5,
    position = 'top-right'
}

-- =============================================================================
-- SHOW NOTIFICATION
-- =============================================================================

function UINotifications.Show(type, message, options)
    options = options or {}

    local notification = {
        id = UINotifications.nextId,
        type = type or 'info', -- success, error, warning, info
        message = message,
        icon = options.icon or UINotifications.GetIcon(type),
        duration = options.duration or UINotifications.defaultDuration,
        position = options.position or UINotifications.position,
        createdAt = GetGameTimer(),
        alpha = 0, -- For fade-in
        visible = true
    }

    UINotifications.nextId = UINotifications.nextId + 1

    -- Add to active
    table.insert(UINotifications.active, notification)

    -- Cleanup old notifications
    while #UINotifications.active > UINotifications.maxVisible do
        table.remove(UINotifications.active, 1)
    end

    -- Auto-hide after duration
    Citizen.SetTimeout(notification.duration, function()
        UINotifications.Remove(notification.id)
    end)

    -- Play sound
    PlaySoundFrontend(-1, UINotifications.GetSound(type), "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    return notification.id
end

-- =============================================================================
-- REMOVE NOTIFICATION
-- =============================================================================

function UINotifications.Remove(id)
    for i, notif in ipairs(UINotifications.active) do
        if notif.id == id then
            notif.visible = false

            -- Remove after fade-out
            Citizen.SetTimeout(300, function()
                for j, n in ipairs(UINotifications.active) do
                    if n.id == id then
                        table.remove(UINotifications.active, j)
                        break
                    end
                end
            end)

            break
        end
    end
end

-- =============================================================================
-- RENDERING
-- =============================================================================

Citizen.CreateThread(function()
    while true do
        if #UINotifications.active > 0 then
            UINotifications.RenderAll()
        end

        Citizen.Wait(0)
    end
end)

function UINotifications.RenderAll()
    local theme = UI.Theme or {}

    -- Calculate position
    local baseX, baseY = UINotifications.GetPosition()
    local width = 0.25
    local height = 0.045
    local spacing = 0.005

    for i, notif in ipairs(UINotifications.active) do
        local y = baseY + (i - 1) * (height + spacing)

        -- Fade-in/out animation
        local now = GetGameTimer()
        local age = now - notif.createdAt
        local timeLeft = notif.duration - age

        if age < 300 then
            -- Fade-in
            notif.alpha = math.min(255, (age / 300) * 255)
        elseif timeLeft < 300 and notif.visible then
            -- Fade-out
            notif.alpha = math.max(0, (timeLeft / 300) * 255)
        else
            notif.alpha = 255
        end

        UINotifications.RenderNotification(notif, baseX, y, width, height)
    end
end

function UINotifications.RenderNotification(notif, x, y, width, height)
    local theme = UI.Theme or {}
    local colors = UINotifications.GetColors(notif.type, theme)

    -- Background
    local bgColor = { r = colors.bg.r, g = colors.bg.g, b = colors.bg.b, a = math.floor((colors.bg.a or 200) *
    (notif.alpha / 255)) }
    UIRenderer.DrawBox(x - width, y, width, height, bgColor, nil)

    -- Left border (color indicator)
    local borderColor = { r = colors.border.r, g = colors.border.g, b = colors.border.b, a = math.floor(255 *
    (notif.alpha / 255)) }
    UIRenderer.DrawRect(x - width, y, 0.004, height, borderColor)

    -- Icon
    local iconColor = { r = colors.icon.r, g = colors.icon.g, b = colors.icon.b, a = math.floor(255 * (notif.alpha / 255)) }
    UIRenderer.DrawText(
        x - width + 0.008,
        y + 0.005,
        notif.icon,
        4,
        0.35,
        iconColor
    )

    -- Message
    local textColor = { r = colors.text.r, g = colors.text.g, b = colors.text.b, a = math.floor(255 * (notif.alpha / 255)) }
    UIRenderer.DrawText(
        x - width + 0.025,
        y + 0.005,
        notif.message,
        4,
        0.32,
        textColor
    )

    -- Progress bar (time left)
    local age = GetGameTimer() - notif.createdAt
    local progress = 100 - ((age / notif.duration) * 100)

    if progress > 0 then
        local barColor = { r = colors.border.r, g = colors.border.g, b = colors.border.b, a = math.floor(150 *
        (notif.alpha / 255)) }
        local barWidth = (width - 0.01) * (progress / 100)
        UIRenderer.DrawRect(x - width + 0.005, y + height - 0.003, barWidth, 0.002, barColor)
    end
end

-- =============================================================================
-- HELPERS
-- =============================================================================

function UINotifications.GetPosition()
    local positions = {
        ['top-left'] = { 0.015, 0.015 },
        ['top-center'] = { 0.5, 0.015 },
        ['top-right'] = { 0.985, 0.015 },
        ['bottom-left'] = { 0.015, 0.85 },
        ['bottom-center'] = { 0.5, 0.85 },
        ['bottom-right'] = { 0.985, 0.85 },
    }

    local pos = positions[UINotifications.position] or positions['top-right']
    return pos[1], pos[2]
end

function UINotifications.GetColors(type, theme)
    local presets = {
        success = {
            bg = { r = 0, g = 100, b = 0, a = 200 },
            border = { r = 0, g = 255, b = 0, a = 255 },
            icon = { r = 0, g = 255, b = 0, a = 255 },
            text = { r = 255, g = 255, b = 255, a = 255 }
        },
        error = {
            bg = { r = 100, g = 0, b = 0, a = 200 },
            border = { r = 255, g = 50, b = 50, a = 255 },
            icon = { r = 255, g = 50, b = 50, a = 255 },
            text = { r = 255, g = 255, b = 255, a = 255 }
        },
        warning = {
            bg = { r = 100, g = 70, b = 0, a = 200 },
            border = { r = 255, g = 150, b = 0, a = 255 },
            icon = { r = 255, g = 150, b = 0, a = 255 },
            text = { r = 255, g = 255, b = 255, a = 255 }
        },
        info = {
            bg = { r = 0, g = 50, b = 100, a = 200 },
            border = { r = 100, g = 150, b = 255, a = 255 },
            icon = { r = 100, g = 150, b = 255, a = 255 },
            text = { r = 255, g = 255, b = 255, a = 255 }
        }
    }

    return presets[type] or presets.info
end

function UINotifications.GetIcon(type)
    local icons = {
        success = '✅',
        error = '❌',
        warning = '⚠️',
        info = 'ℹ️'
    }

    return icons[type] or icons.info
end

function UINotifications.GetSound(type)
    local sounds = {
        success = "CHECKPOINT_PERFECT",
        error = "CHECKPOINT_MISSED",
        warning = "CHECKPOINT_UNDER_THE_BRIDGE",
        info = "HIGHLIGHT"
    }

    return sounds[type] or sounds.info
end

-- =============================================================================
-- API
-- =============================================================================

function UINotifications.Clear()
    UINotifications.active = {}
end

function UINotifications.SetPosition(position)
    UINotifications.position = position
end

print("^2[FD-UI Notifications] Loaded^0")
