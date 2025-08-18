-- Create the invisible button frame
local craftButton = CreateFrame("Frame", "MountedCrafter", UIParent)
craftButton:SetSize(10, 10)
craftButton:SetAlpha(0) -- Make it invisible
craftButton:Hide() 
craftButton:EnableMouse(true)
craftButton:SetPassThroughButtons("LeftButton", "MiddleButton", "Button4", "Button5")

-- Add visual elements for testing
local buttonBorder = craftButton:CreateTexture(nil, "BORDER")
buttonBorder:SetColorTexture(1, 1, 1, 1) -- White border
buttonBorder:SetPoint("TOPLEFT", craftButton, "TOPLEFT", -1, 1)
buttonBorder:SetPoint("BOTTOMRIGHT", craftButton, "BOTTOMRIGHT", 1, -1)

local buttonTexture = craftButton:CreateTexture(nil, "ARTWORK")
buttonTexture:SetColorTexture(1, 0, 0, 0.5) -- Semi-transparent red
buttonTexture:SetPoint("TOPLEFT", craftButton, "TOPLEFT", 0, 0)
buttonTexture:SetPoint("BOTTOMRIGHT", craftButton, "BOTTOMRIGHT", 0, 0)

-- Mapping of crafting station names to profession IDs
local CRAFTING_STATION_MAP = {
    -- Blacksmithing (164)
    ["Anvil"] = 164,
    ["Forge"] = 164,
    ["Blacksmithing Table"] = 164,
    ["Blacksmithing Anvil"] = 164,
    ["Earthen Forge"] = 164,
    ["Crystal Anvil"] = 164,
    ["Earthen Anvil"] = 164,
    
    -- Alchemy (171)
    ["Alchemy Lab"] = 171,
    ["Alchemy Table"] = 171,
    ["Alchemist's Table"] = 171,
    
    -- Enchanting (333)
    ["Enchanting Table"] = 333,
    ["Enchanting Vellum"] = 333,
    ["Enchanter's Lectern"] = 333,
    
    -- Engineering (202)
    ["Engineering Table"] = 202,
    ["Engineering Workbench"] = 202,
    ["Tinker Table"] = 202,
    ["Tinker's Workbench"] = 202,
    
    -- Leatherworking (165)
    ["Leatherworking Table"] = 165,
    ["Leatherworking Workbench"] = 165,
    
    -- Tailoring (197)
    ["Tailoring Table"] = 197,
    ["Tailoring Loom"] = 197,
    ["Tailor's Work Table"] = 197,
    
    -- Jewelcrafting (755)
    ["Jeweler's Bench"] = 755,
    ["Jewelcrafting Table"] = 755,
    ["Jewelcrafter's Table"] = 755,
    ["Jewelcrafting Workbench"] = 755,
    
    -- Inscription (773)
    ["Inscription Table"] = 773,
    ["Inscription Desk"] = 773,
}

-- Function to check if player knows a profession
local function PlayerKnowsProfession(professionID)
    local prof1, prof2 = GetProfessions()
    if prof1 then
        local _, _, _, _, _, _, skillLine = GetProfessionInfo(prof1)
        if skillLine and skillLine == professionID then
            return true
        end
    end
    if prof2 then
        local _, _, _, _, _, _, skillLine = GetProfessionInfo(prof2)
        if skillLine and skillLine == professionID then
            return true
        end
    end
    return false
end

-- Function to check if we're mousing over a crafting object and return the object name
local function IsMouseOverCraftingObject()
    -- Check for world objects using GameTooltip
    if GameTooltip:IsShown() and GameTooltip:GetAlpha() > 0.9 then
        local tooltipText = GameTooltipTextLeft1:GetText()
        if tooltipText and CRAFTING_STATION_MAP[tooltipText] then
            local professionID = CRAFTING_STATION_MAP[tooltipText]
            -- Only return true if player knows this profession
            if professionID and PlayerKnowsProfession(professionID) then
                return true, tooltipText
            end
        end
    end
    return false, nil
end

-- Function to open tradeskill window for a given profession ID
local function OpenTradeskillWindow(professionID, objectName)
    if C_TradeSkillUI and C_TradeSkillUI.OpenTradeSkill then
        -- Modern API approach
        C_TradeSkillUI.OpenTradeSkill(professionID)
        -- print("Opened " .. objectName .. " (Profession ID: " .. professionID .. ")")
    else
        -- Fallback to macro approach - try to cast the profession
        local professionNames = {
            [164] = "Blacksmithing",
            [171] = "Alchemy",
            [333] = "Enchanting",
            [202] = "Engineering",
            [165] = "Leatherworking",
            [197] = "Tailoring",
            [755] = "Jewelcrafting",
            [773] = "Inscription",
            [185] = "Cooking",
            [182] = "Herbalism",
            [186] = "Mining",
            [960] = "Runeforging"
        }
        
        local professionName = professionNames[professionID]
        if professionName then
            RunMacroText("/cast " .. professionName)
            print("Attempted to open " .. professionName .. " via macro")
        else
            print("Unknown profession ID: " .. professionID)
        end
    end
end

-- Function to position the button under the cursor
local function PositionButtonUnderCursor()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    craftButton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end

-- Main update function
local function UpdateCraftingButton()
    local isOverCraftingObject, objectName = IsMouseOverCraftingObject()
    
    if isOverCraftingObject then
        -- PositionButtonUnderCursor()
        craftButton:Show()
    elseif craftButton:IsShown() then
        craftButton:Hide()
    end
end

craftButton:SetScript("OnEnter", function(self)
    SetCursor("INTERACT_CURSOR") -- Shows the gear cursor

    GameTooltip:Show()
end)

craftButton:SetScript("OnLeave", function(self)
    SetCursor("POINT_CURSOR") -- Reset to normal cursor

    GameTooltip:Hide()
    craftButton:Hide()
end)

-- Set up the button mouse up action
craftButton:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
        local isOverCraftingObject, objectName = IsMouseOverCraftingObject()
        
        if isOverCraftingObject and objectName then
            local professionID = CRAFTING_STATION_MAP[objectName]

            if professionID then
                OpenTradeskillWindow(professionID, objectName)
            end
        else
            print("No crafting station detected")
        end
    end
end)

-- Event frame for handling events
local eventFrame = CreateFrame("Frame")

-- -- Update on mouse movement
-- eventFrame:SetScript("OnUpdate", function(self, elapsed)
--     -- self.timeSinceLastUpdate = (self.timeSinceLastUpdate or 0) + elapsed

--     -- -- Only update every 0.1 seconds to avoid performance issues
--     -- if self.timeSinceLastUpdate >= 0.01 then
--     --     UpdateCraftingButton()
--     --     self.timeSinceLastUpdate = 0
--     -- end
--     UpdateCraftingButton()
-- end)

eventFrame:RegisterEvent("WORLD_CURSOR_TOOLTIP_UPDATE")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    UpdateCraftingButton()
end)

-- Enable mouse interaction only when mouse button is pressed
-- local mouseFrame = CreateFrame("Frame")
-- mouseFrame:RegisterEvent("GLOBAL_MOUSE_DOWN")
-- mouseFrame:RegisterEvent("GLOBAL_MOUSE_UP")

-- mouseFrame:SetScript("OnEvent", function(self, event, button)
--     if event == "GLOBAL_MOUSE_DOWN" and button == "RightButton" and craftButton:IsShown() then
--         craftButton:EnableMouse(true)
--     elseif event == "GLOBAL_MOUSE_UP" then
--         craftButton:EnableMouse(false)
--     end
-- end)


hooksecurefunc(GameTooltip, "Show", function(self)
    local tooltipText = GameTooltipTextLeft1:GetText()
    if tooltipText and CRAFTING_STATION_MAP[tooltipText] then
    end
    -- Crafting station detected, update button
    UpdateCraftingButton()
    PositionButtonUnderCursor()
end)

hooksecurefunc("GameTooltip_Hide", function(self)
    -- Crafting station detected, update button
    UpdateCraftingButton()
end)

-- Optional: Add visual feedback when button is active (for testing)
local function ToggleVisibility(show)
    if show then
        craftButton:SetAlpha(1) -- Make fully visible for testing
        print("Crafting button now visible for testing")
    else
        craftButton:SetAlpha(0) -- Make invisible again
        print("Crafting button now invisible")
    end
end

-- Slash command for testing
SLASH_MOUNTEDCRAFTER1 = "/mountedcrafter"
SLASH_MOUNTEDCRAFTER2 = "/mc"
SlashCmdList["MOUNTEDCRAFTER"] = function(msg)
    if msg == "show" then
        ToggleVisibility(true)
    elseif msg == "hide" then
        ToggleVisibility(false)
        print("Hiding crafting button")
    else
        print("MountedCrafter commands:")
        print("/mountedcrafter or /mc show - Toggle button visibility")
        print("/mountedcrafter or /mc hide - Hide button")
    end
end
