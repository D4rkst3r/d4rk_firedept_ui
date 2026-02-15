-- =============================================================================
-- HIGH-LEVEL SYSTEM STUBS
-- =============================================================================

-- These can be expanded in future versions

-- =============================================================================
-- HUD MANAGER
-- =============================================================================

UIHUD = {
    panels = {}
}

function UIHUD.Register(id, panel)
    UIHUD.panels[id] = panel
end

function UIHUD.Get(id)
    return UIHUD.panels[id]
end

print("^2[FD-UI HUD Manager] Loaded^0")

-- =============================================================================
-- DIALOG SYSTEM (STUB)
-- =============================================================================

UIDialogs = {}

function UIDialogs.Show(config)
    -- TODO: Implement modal dialogs
    print("^3[FD-UI Dialogs] Not yet implemented^0")
    return nil
end

function UIDialogs.Input(title, placeholder, callback)
    -- TODO: Implement input dialog
    print("^3[FD-UI Input] Not yet implemented^0")
    return nil
end

print("^2[FD-UI Dialogs] Loaded (Stub)^0")

-- =============================================================================
-- PROGRESS SYSTEM (STUB)
-- =============================================================================

UIProgress = {}

function UIProgress.Show(label, duration, options)
    -- TODO: Implement progress circles
    print("^3[FD-UI Progress] Not yet implemented^0")
    return nil
end

print("^2[FD-UI Progress] Loaded (Stub)^0")

-- =============================================================================
-- MENU SYSTEM (STUB)
-- =============================================================================

UIMenus = {}

function UIMenus.Show(config)
    -- TODO: Implement context menus
    print("^3[FD-UI Menus] Not yet implemented^0")
    return nil
end

print("^2[FD-UI Menus] Loaded (Stub)^0")

-- =============================================================================
-- 3D INTERACTIONS (STUB)
-- =============================================================================

UIInteractions = {}

function UIInteractions.Show(coords, text, options)
    -- TODO: Implement 3D prompts
    print("^3[FD-UI Interactions] Not yet implemented^0")
    return nil
end

print("^2[FD-UI Interactions] Loaded (Stub)^0")
