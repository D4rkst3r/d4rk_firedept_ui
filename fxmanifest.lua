fx_version 'cerulean'
game 'gta5'

author 'D4rkst3r'
description 'Professional UI Library for FiveM'
version '1.0.0'

lua54 'yes'

-- =============================================================================
-- SHARED FILES (Client & Server)
-- =============================================================================

shared_scripts {
    'config.lua'
}

-- =============================================================================
-- CLIENT FILES (LOAD ORDER IS CRITICAL!)
-- =============================================================================

client_scripts {
    'core/stubs.lua',            -- State, Events, Layout, Animations
    'core/renderer.lua',         -- Drawing Engine
    'themes/themes.lua',         -- Theme System
    'components/panel.lua',      -- Panel Component
    'components/stubs.lua',      -- Other Components (Button, Text, etc.)
    'systems/stubs.lua',         -- HUD, Dialogs, Progress, Menus, Interactions
    'systems/notifications.lua', -- Notification System
    'lib.lua'
}

-- =============================================================================
-- EXPORTS
-- =============================================================================

-- Main API Export
export 'GetAPI'

-- Direct Exports (for advanced users)
exports {
    'GetAPI'
}

print("^2[FD-UI Library] fxmanifest loaded^0")
