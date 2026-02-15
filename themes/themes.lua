-- =============================================================================
-- UI THEME SYSTEM
-- =============================================================================

UITheme = {
    themes = {},
    current = nil
}

-- =============================================================================
-- DEFAULT THEME
-- =============================================================================

UITheme.themes.default = {
    name = 'Default',

    panel = {
        background = { r = 0, g = 0, b = 0, a = 180 },
        border = { r = 255, g = 150, b = 0, a = 255 },
        divider = { r = 100, g = 100, b = 100, a = 255 }
    },

    text = {
        primary = { r = 255, g = 255, b = 255, a = 255 },
        secondary = { r = 200, g = 200, b = 200, a = 255 },
        success = { r = 0, g = 255, b = 0, a = 255 },
        warning = { r = 255, g = 150, b = 0, a = 255 },
        error = { r = 255, g = 50, b = 50, a = 255 }
    },

    progressBar = {
        background = { r = 50, g = 50, b = 50, a = 200 },
        high = { r = 0, g = 255, b = 0, a = 255 },
        medium = { r = 255, g = 200, b = 0, a = 255 },
        low = { r = 255, g = 50, b = 50, a = 255 }
    },

    notification = {
        success = { r = 0, g = 255, b = 0, a = 255 },
        error = { r = 255, g = 50, b = 50, a = 255 },
        warning = { r = 255, g = 150, b = 0, a = 255 },
        info = { r = 100, g = 150, b = 255, a = 255 }
    }
}

-- =============================================================================
-- FIRE THEME (Orange/Red)
-- =============================================================================

UITheme.themes.fire = {
    name = 'Fire',

    panel = {
        background = { r = 20, g = 0, b = 0, a = 190 },
        border = { r = 255, g = 100, b = 0, a = 255 },
        divider = { r = 150, g = 50, b = 0, a = 255 }
    },

    text = {
        primary = { r = 255, g = 200, b = 150, a = 255 },
        secondary = { r = 200, g = 150, b = 100, a = 255 },
        success = { r = 255, g = 150, b = 0, a = 255 },
        warning = { r = 255, g = 100, b = 0, a = 255 },
        error = { r = 255, g = 50, b = 0, a = 255 }
    },

    progressBar = {
        background = { r = 50, g = 20, b = 0, a = 200 },
        high = { r = 255, g = 150, b = 0, a = 255 },
        medium = { r = 255, g = 100, b = 0, a = 255 },
        low = { r = 255, g = 50, b = 0, a = 255 }
    }
}

-- =============================================================================
-- DARK THEME
-- =============================================================================

UITheme.themes.dark = {
    name = 'Dark',

    panel = {
        background = { r = 10, g = 10, b = 10, a = 220 },
        border = { r = 50, g = 50, b = 50, a = 255 },
        divider = { r = 40, g = 40, b = 40, a = 255 }
    },

    text = {
        primary = { r = 220, g = 220, b = 220, a = 255 },
        secondary = { r = 150, g = 150, b = 150, a = 255 },
        success = { r = 100, g = 200, b = 100, a = 255 },
        warning = { r = 200, g = 150, b = 50, a = 255 },
        error = { r = 200, g = 80, b = 80, a = 255 }
    },

    progressBar = {
        background = { r = 30, g = 30, b = 30, a = 200 },
        high = { r = 100, g = 200, b = 100, a = 255 },
        medium = { r = 200, g = 150, b = 50, a = 255 },
        low = { r = 200, g = 80, b = 80, a = 255 }
    }
}

-- =============================================================================
-- THEME MANAGEMENT
-- =============================================================================

function UITheme.Load(themeName)
    local theme = UITheme.themes[themeName] or UITheme.themes.default
    UITheme.current = theme

    print("^2[FD-UI Theme] Loaded: " .. theme.name .. "^0")

    return theme
end

function UITheme.Register(themeName, themeData)
    UITheme.themes[themeName] = themeData

    print("^2[FD-UI Theme] Registered: " .. themeName .. "^0")
end

function UITheme.Get()
    return UITheme.current or UITheme.themes.default
end

print("^2[FD-UI Theme System] Loaded^0")
