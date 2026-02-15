-- =============================================================================
-- CORE SYSTEM STUBS
-- =============================================================================

-- These are minimal implementations - can be expanded later

-- =============================================================================
-- STATE MANAGEMENT
-- =============================================================================

UIState = {
    data = {}
}

function UIState.Set(key, value)
    UIState.data[key] = value
end

function UIState.Get(key, default)
    return UIState.data[key] or default
end

function UIState.Clear()
    UIState.data = {}
end

print("^2[FD-UI State] Loaded^0")

-- =============================================================================
-- EVENT SYSTEM
-- =============================================================================

UIEvents = {
    listeners = {}
}

function UIEvents.On(event, callback)
    if not UIEvents.listeners[event] then
        UIEvents.listeners[event] = {}
    end
    table.insert(UIEvents.listeners[event], callback)
end

function UIEvents.Trigger(event, ...)
    if UIEvents.listeners[event] then
        for _, callback in ipairs(UIEvents.listeners[event]) do
            callback(...)
        end
    end
end

print("^2[FD-UI Events] Loaded^0")

-- =============================================================================
-- LAYOUT ENGINE
-- =============================================================================

UILayout = {}

function UILayout.Calculate(position, width, height)
    -- Stub: Returns calculated position
    return position
end

print("^2[FD-UI Layout] Loaded^0")

-- =============================================================================
-- ANIMATION SYSTEM
-- =============================================================================

UIAnimations = {}

function UIAnimations.FadeIn(component, duration, callback)
    -- Stub: Fade in animation
    if callback then callback() end
end

function UIAnimations.FadeOut(component, duration, callback)
    -- Stub: Fade out animation
    if callback then callback() end
end

function UIAnimations.Slide(component, from, to, duration, callback)
    -- Stub: Slide animation
    if callback then callback() end
end

print("^2[FD-UI Animations] Loaded^0")
