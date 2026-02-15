-- =============================================================================
-- UI PANEL COMPONENT
-- =============================================================================

UIPanel = {}
UIPanel.__index = UIPanel

-- =============================================================================
-- CONSTRUCTOR
-- =============================================================================

function UIPanel.new(config)
    local self = setmetatable({}, UIPanel)

    self.id = config.id
    self.position = config.position or 'left-center'
    self.width = config.width or 0.20
    self.theme = config.theme or 'default'
    self.visible = false
    self.elements = {}
    self.data = {}
    self.autoHide = config.autoHide ~= false
    self.lastUpdate = 0
    self.hideDelay = config.hideDelay or 500

    -- Calculate actual position
    self.x, self.y = self:CalculatePosition()

    return self
end

-- =============================================================================
-- POSITION CALCULATION
-- =============================================================================

function UIPanel:CalculatePosition()
    local pos = self.position

    -- Predefined positions
    local positions = {
        ['left-top'] = { 0.015, 0.015 },
        ['left-center'] = { 0.015, 0.45 },
        ['left-bottom'] = { 0.015, 0.85 },
        ['right-top'] = { 0.985, 0.015 },
        ['right-center'] = { 0.985, 0.45 },
        ['right-bottom'] = { 0.985, 0.85 },
        ['center-top'] = { 0.5, 0.015 },
        ['center'] = { 0.5, 0.5 },
        ['center-bottom'] = { 0.5, 0.85 },
    }

    if type(pos) == 'string' and positions[pos] then
        return positions[pos][1], positions[pos][2]
    elseif type(pos) == 'table' and pos.x and pos.y then
        return pos.x, pos.y
    else
        return 0.015, 0.5 -- Default: left-center
    end
end

-- =============================================================================
-- ELEMENT MANAGEMENT
-- =============================================================================

function UIPanel:AddText(key, options)
    options = options or {}

    table.insert(self.elements, {
        type = 'text',
        key = key,
        icon = options.icon,
        format = options.format or '%s',
        size = options.size or 'normal', -- small, normal, large
        color = options.color,
        align = options.align or 'left'
    })

    return self
end

function UIPanel:AddProgressBar(key, options)
    options = options or {}

    table.insert(self.elements, {
        type = 'progressbar',
        key = key,
        label = options.label,
        showPercent = options.showPercent ~= false,
        colorMode = options.colorMode or 'gradient', -- solid, gradient
        color = options.color,
        height = options.height or 0.015
    })

    return self
end

function UIPanel:AddSpacer(height)
    table.insert(self.elements, {
        type = 'spacer',
        height = height or 0.01
    })

    return self
end

function UIPanel:AddDivider()
    table.insert(self.elements, {
        type = 'divider'
    })

    return self
end

-- =============================================================================
-- DATA UPDATE
-- =============================================================================

function UIPanel:Show(data)
    self.data = data or self.data
    self.visible = true
    self.lastUpdate = GetGameTimer()

    return self
end

function UIPanel:Update(data)
    if data then
        for key, value in pairs(data) do
            self.data[key] = value
        end
    end

    self.lastUpdate = GetGameTimer()

    return self
end

function UIPanel:Hide()
    self.visible = false

    return self
end

function UIPanel:Toggle()
    self.visible = not self.visible

    return self
end

-- =============================================================================
-- RENDERING
-- =============================================================================

function UIPanel:Render()
    if not self.visible then
        return
    end

    -- Auto-hide check
    if self.autoHide then
        local now = GetGameTimer()
        if (now - self.lastUpdate) > self.hideDelay then
            self:Hide()
            return
        end
    end

    local theme = UI.Theme or {}
    local x = self.x
    local y = self.y
    local width = self.width
    local lineHeight = 0.025

    -- Calculate total height
    local totalHeight = 0.02 -- Padding
    for _, element in ipairs(self.elements) do
        if element.type == 'text' then
            totalHeight = totalHeight + lineHeight
        elseif element.type == 'progressbar' then
            totalHeight = totalHeight + lineHeight * 2
        elseif element.type == 'spacer' then
            totalHeight = totalHeight + (element.height or 0.01)
        elseif element.type == 'divider' then
            totalHeight = totalHeight + 0.005
        end
    end
    totalHeight = totalHeight + 0.02 -- Bottom padding

    -- Draw background
    local bgColor = theme.panel and theme.panel.background or { r = 0, g = 0, b = 0, a = 180 }
    local borderColor = theme.panel and theme.panel.border or { r = 255, g = 150, b = 0, a = 255 }

    UIRenderer.DrawBox(x, y, width, totalHeight, bgColor, borderColor)

    -- Draw elements
    local currentY = y + 0.01

    for _, element in ipairs(self.elements) do
        if element.type == 'text' then
            self:RenderText(element, x, currentY, width)
            currentY = currentY + lineHeight
        elseif element.type == 'progressbar' then
            self:RenderProgressBar(element, x, currentY, width)
            currentY = currentY + lineHeight * 2
        elseif element.type == 'spacer' then
            currentY = currentY + (element.height or 0.01)
        elseif element.type == 'divider' then
            local dividerColor = theme.panel and theme.panel.divider or { r = 100, g = 100, b = 100, a = 255 }
            UIRenderer.DrawRect(x + 0.01, currentY, width - 0.02, 0.002, dividerColor)
            currentY = currentY + 0.005
        end
    end
end

function UIPanel:RenderText(element, x, y, width)
    local theme = UI.Theme or {}
    local value = self.data[element.key] or ''

    -- Format value
    local text = element.format:format(value)

    -- Add icon
    if element.icon then
        text = element.icon .. ' ' .. text
    end

    -- Size
    local scale = 0.35
    if element.size == 'small' then
        scale = 0.28
    elseif element.size == 'large' then
        scale = 0.42
    end

    -- Color
    local color = element.color or (theme.text and theme.text.primary) or { r = 255, g = 255, b = 255, a = 255 }

    UIRenderer.DrawText(x + 0.01, y, text, 4, scale, color, element.align)
end

function UIPanel:RenderProgressBar(element, x, y, width)
    local theme = UI.Theme or {}
    local value = self.data[element.key] or 0

    -- Label
    if element.label then
        local labelText = element.label
        if element.showPercent then
            labelText = labelText .. string.format(": %.0f%%", value)
        end

        local labelColor = theme.text and theme.text.secondary or { r = 200, g = 200, b = 200, a = 255 }
        UIRenderer.DrawText(x + 0.01, y, labelText, 4, 0.28, labelColor)
    end

    -- Bar
    local barY = y + 0.012
    local barWidth = width - 0.02

    local colors = {}
    if element.colorMode == 'gradient' then
        colors.fill = UIRenderer.GetProgressColor(value)
    elseif element.color then
        colors.fill = element.color
    end

    UIRenderer.DrawProgressBar(x + 0.01, barY, barWidth, element.height, value, colors)
end

-- =============================================================================
-- UTILITIES
-- =============================================================================

function UIPanel:SetPosition(position)
    self.position = position
    self.x, self.y = self:CalculatePosition()

    return self
end

function UIPanel:SetWidth(width)
    self.width = width

    return self
end

function UIPanel:Clear()
    self.elements = {}

    return self
end

function UIPanel:Destroy()
    self.visible = false
    self.elements = {}
    self.data = {}
end

print("^2[FD-UI Panel] Loaded^0")
