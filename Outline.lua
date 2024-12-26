-- Aseprite script: Replace color based on neighbors with user-selected default colors

-- Function to process the image and replace colors based on neighbor checks
local function replaceColorBasedOnNeighbors(dlg, targetColor, outlineColor)
    dlg:modify{ id= "status",
            text= "Processing" }
    local sprite = app.activeSprite
    if sprite == nil then
        dlg:modify{ id= "status",
            text= "No sprite" }
        return
    end

    local cel = app.activeCel
    if cel == nil then
        dlg:modify{ id= "status",
            text= "No cell" }
        return
    end

    local image = cel.image

    for y = 0, image.height - 1 do
        for x = 0, image.width - 1 do
            local pixelValue = image:getPixel(x, y)
            local alpha = app.pixelColor.rgbaA(pixelValue)
            if alpha >= 1 then
                for dx = -1, 1 do
                    for dy = -1, 1 do
                       if not (dx == 0 and dy == 0) then
                            local nx, ny = x + dx, y + dy
                            if nx >= 0 and nx < image.width and ny >= 0 and ny < image.height then
                                local neighborColor = image:getPixel(nx, ny)
                                if neighborColor ~= targetColor then
                                    image:drawPixel(nx, ny, outlineColor)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Show input dialog for colors
local function createDialogue()
    local fgColor = app.fgColor -- Foreground color as default target color
    local bgColor = app.bgColor -- Background color as default outline color

    local dlg
    dlg =
    Dialog {
    title = "Color As Position"
    }
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
        focus = true,
        onclick = function()
            local data = dlg.data
            local targetColor = app.pixelColor.rgba(
                data.targetColor.red,
                data.targetColor.green,
                data.targetColor.blue,
                data.targetColor.alpha
            )
            local outlineColor = app.pixelColor.rgba(
                data.outlineColor.red,
                data.outlineColor.green,
                data.outlineColor.blue,
                data.outlineColor.alpha
            )

            app.transaction(function()
                replaceColorBasedOnNeighbors(dlg, targetColor, outlineColor)
            end)
        end
    }
    dlg:button{
        id = "cancel",
        text = "Cancel"
    }
    dlg:show{ wait = true }
end

createDialogue()
