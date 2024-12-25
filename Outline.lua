-- Aseprite script: Replace color based on neighbors with user-selected default colors


-- Helper function to get a pixel's color safely (handles out-of-bounds)
function getPixelSafe(image, x, y)
    if x < 0 or y < 0 or x >= image.width or y >= image.height then
        return nil -- Out of bounds
    end
    return image:getPixel(x, y)
end

-- Function to process the image and replace colors based on neighbor checks
function replaceColorBasedOnNeighbors(dlg)
    -- Get the currently selected color from the active palette
    local fgColor = app.fgColor -- Foreground color as default target color
    local bgColor = app.bgColor -- Background color as default outline color
    
    local targetColor = app.pixelColor.rgba(dlg.targetColor.red, dlg.targetColor.green, dlg.targetColor.blue, dlg.targetColor.alpha)
    local outlineColor = app.pixelColor.rgba(dlg.outlineColor.red, dlg.outlineColor.green, dlg.outlineColor.blue, dlg.outlineColor.alpha)

    local cel = sprite.cels[1]
    if not cel then
        app.alert("No cel in the active sprite!")
        return
    end

    local image = cel.image:clone() -- Work on a clone to prevent modifying during checks
    local processedImage = cel.image

    for y = 0, image.height - 1 do
        for x = 0, image.width - 1 do
            local currentColor = image:getPixel(x, y)
            if currentColor == targetColor then
                -- Check the 8 neighbors
                local isBoundaryPixel = false
                for dx = -1, 1 do
                    for dy = -1, 1 do
                        if not (dx == 0 and dy == 0) then -- Skip the current pixel
                            local neighborColor = getPixelSafe(image, x + dx, y + dy)
                            if neighborColor and neighborColor ~= targetColor then
                                isBoundaryPixel = true
                                break
                            end
                        end
                    end
                    if isBoundaryPixel then break end
                end

                -- Replace the pixel if it is a boundary pixel
                if isBoundaryPixel then
                    processedImage:putPixel(x, y, outlineColor)
                end
            end
        end
    end
end

-- Show input dialog for colors
function createDialogue()
    local dlg = Dialog("Outline Color Tool")
    
    dlg:color{
        id = "targetColor",
        label = "Target Color",
        color = fgColor, -- Default: Foreground color
    }
    dlg:color{
        id = "outlineColor",
        label = "Outline Color",
        color = bgColor, -- Default: Background color
    }
    dlg:button{
        id = "ok",
        text = "OK",
        focus = true
        onclick = function()
            replaceColorBasedOnNeighbors(dlg)
        end
    }
    dlg:button{
        id = "cancel",
        text = "Cancel"
    }
    dlg:show{ 
        wait=false 
    }
end
    
do
  createDialogue()
end
