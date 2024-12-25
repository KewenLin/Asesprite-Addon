-- Aseprite script: Replace color based on neighbors

function getPixelColor(image, x, y)
    if x < 0 or y < 0 or x >= image.width or y >= image.height then
        return nil -- Out of bounds
    end
    return image:getPixel(x, y)
end

function replaceColorBasedOnNeighbors(sprite, targetColor, replacementColor)
    local image = sprite.cels[1].image:clone() -- Clone the image to avoid modifying during iteration

    for y = 0, image.height - 1 do
        for x = 0, image.width - 1 do
            local currentColor = image:getPixel(x, y)
            if currentColor == targetColor then
                -- Check 8 directions
                local isIsolated = false
                for dx = -1, 1 do
                    for dy = -1, 1 do
                        if not (dx == 0 and dy == 0) then -- Skip the center pixel
                            local neighborColor = getPixelColor(image, x + dx, y + dy)
                            if neighborColor ~= targetColor then
                                isIsolated = true
                                break
                            end
                        end
                    end
                    if isIsolated then break end
                end
                -- Replace color if isolated
                if isIsolated then
                    sprite.cels[1].image:putPixel(x, y, replacementColor)
                end
            end
        end
    end
end

-- Get user inputs
local sprite = app.activeSprite
if not sprite then
    app.alert("No active sprite!")
    return
end

local targetColor = app.pixelColor.rgba(255, 0, 0, 255) -- Red (modifiable)
local replacementColor = app.pixelColor.rgba(0, 0, 255, 255) -- Blue (modifiable)

app.transaction(function()
    replaceColorBasedOnNeighbors(sprite, targetColor, replacementColor)
end)

app.refresh()
