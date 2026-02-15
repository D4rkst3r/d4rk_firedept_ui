-- =============================================================================
-- FIREDEPT UI LIBRARY - MAIN API (EVENT-BASED!)
-- =============================================================================

UI = {
    _version = '1.0.0',
    _components = {},
    _themes = {},
    _state = {},
    _ready = false
}

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

function UI.Initialize()
    print("^2[FD-UI] Initializing UI Library v" .. UI._version .. "^0")

    -- Load Core Systems
    UI.Renderer = UIRenderer
    UI.State = UIState
    UI.Layout = UILayout
    UI.Events = UIEvents
    UI.Animations = UIAnimations

    -- Load Components
    UI.Panel = UIPanel
    UI.ProgressBar = UIProgressBar
    UI.Text = UIText
    UI.Button = UIButton

    -- Load Systems
    UI.HUD = UIHUD
    UI.Notifications = UINotifications
    UI.Dialogs = UIDialogs
    UI.Menus = UIMenus
    UI.Progress = UIProgress
    UI.Interactions = UIInteractions

    -- Load Theme
    UI.Theme = UITheme.Load('default')

    -- Start Renderer
    UI.Renderer.Start()

    -- ✅ NOW SET CreatePanel (after UI.Panel is loaded!)
    UI.CreatePanel = function(config)
        if not config.id then
            error("Panel requires an 'id'")
        end

        if UI._components[config.id] then
            print("^3[FD-UI] Warning: Panel '" .. config.id .. "' already exists, returning existing^0")
            return UI._components[config.id]
        end

        local panel = UI.Panel.new(config)
        UI._components[config.id] = panel

        return panel
    end

    UI._ready = true

    print("^2[FD-UI] ✓ Library Ready!^0")
    print("^2[FD-UI] ✓ Components: " .. #UI._components .. "^0")
    print("^2[FD-UI] ✓ Theme: " .. UI.Theme.name .. "^0")

    -- ✅ TRIGGER EVENT!
    TriggerEvent('firedept_ui:ready')
end

-- =============================================================================
-- HIGH-LEVEL API - PANELS (other methods)
-- =============================================================================

function UI.GetPanel(id)
    return UI._components[id]
end

function UI.RemovePanel(id)
    if UI._components[id] then
        UI._components[id]:Destroy()
        UI._components[id] = nil
    end
end

-- =============================================================================
-- HIGH-LEVEL API - NOTIFICATIONS
-- =============================================================================

function UI.Notify(type, message, options)
    return UI.Notifications.Show(type, message, options)
end

function UI.Success(message, duration)
    return UI.Notify('success', message, { duration = duration })
end

function UI.Error(message, duration)
    return UI.Notify('error', message, { duration = duration })
end

function UI.Warning(message, duration)
    return UI.Notify('warning', message, { duration = duration })
end

function UI.Info(message, duration)
    return UI.Notify('info', message, { duration = duration })
end

-- =============================================================================
-- HIGH-LEVEL API - DIALOGS
-- =============================================================================

function UI.Dialog(config)
    return UI.Dialogs.Show(config)
end

function UI.Confirm(title, message, callback)
    return UI.Dialog({
        title = title,
        message = message,
        buttons = {
            { label = 'Yes', callback = callback },
            { label = 'No' }
        }
    })
end

function UI.Alert(title, message)
    return UI.Dialog({
        title = title,
        message = message,
        buttons = {
            { label = 'OK' }
        }
    })
end

function UI.Input(title, placeholder, callback)
    return UI.Dialogs.Input(title, placeholder, callback)
end

-- =============================================================================
-- HIGH-LEVEL API - PROGRESS
-- =============================================================================

function UI.Progress(label, duration, options)
    return UI.Progress.Show(label, duration, options)
end

-- =============================================================================
-- HIGH-LEVEL API - MENUS
-- =============================================================================

function UI.Menu(config)
    return UI.Menus.Show(config)
end

-- =============================================================================
-- HIGH-LEVEL API - 3D INTERACTIONS
-- =============================================================================

function UI.ShowInteraction(coords, text, options)
    return UI.Interactions.Show(coords, text, options)
end

-- =============================================================================
-- UTILITY API
-- =============================================================================

function UI.SetTheme(themeName)
    UI.Theme = UITheme.Load(themeName)

    for id, component in pairs(UI._components) do
        if component.ApplyTheme then
            component:ApplyTheme(UI.Theme)
        end
    end
end

function UI.IsReady()
    return UI._ready
end

function UI.GetVersion()
    return UI._version
end

function UI.Debug(enabled)
    UI.Renderer.Debug = enabled
    print("^3[FD-UI] Debug mode: " .. (enabled and "ON" or "OFF") .. "^0")
end

-- =============================================================================
-- STATE MANAGEMENT
-- =============================================================================

function UI.GetState(key)
    return UI._state[key]
end

function UI.SetState(key, value)
    UI._state[key] = value
    UI.Events.Trigger('state:changed', key, value)
end

-- =============================================================================
-- COMPONENT REGISTRY
-- =============================================================================

function UI.RegisterComponent(id, component)
    UI._components[id] = component
end

function UI.GetAllComponents()
    return UI._components
end

function UI.ClearAll()
    for id, component in pairs(UI._components) do
        if component.Destroy then
            component:Destroy()
        end
    end
    UI._components = {}
end

-- =============================================================================
-- EXPORTS
-- =============================================================================

function GetAPI()
    -- ✅ Return immediately! CreatePanel will wait internally
    return UI
end

exports('GetAPI', GetAPI)

-- =============================================================================
-- AUTO-INITIALIZE
-- =============================================================================

Citizen.CreateThread(function()
    -- Wait for game to be ready
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(100)
    end

    -- Initialize immediately!
    UI.Initialize()
end)

print("^2[FD-UI] Library loaded^0")
