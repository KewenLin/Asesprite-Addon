-- Function to process the image and replace colors based on neighbor checks
function replaceColorBasedOnNeighbors(sprite, targetColor, outlineColor, dlg)
    if not dlg then
        app.alert("Dialog reference is missing!")
        return
    end

    dlg:modify{ id = "status", text = "Processing..." }

    local cel = app.activeCel
    if not cel then
        dlg:modify{ id = "status", text = "No active cel found!" }
        return
    end

    local image = cel.image
    local mask = app.activeImage

    if not mask then
        dlg:modify{ id = "status", text = "No active mask, processing entire image." }
    end

    local width, height = image.width, image.height

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            -- Skip pixels outside the mask, if a mask is active
            if not mask or mask:getPixel(x, y) > 0 then
                local pixelValue = image:getPixel(x, y)
                local alpha = app.pixelColor.rgbaA(pixelValue)

                if alpha >= 1 and pixelValue == targetColor then
                    -- Check the 8 neighbors
                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            if not (dx == 0 and dy == 0) then
                                local nx, ny = x + dx, y + dy
                                if nx >= 0 and nx < width and ny >= 0 and ny < height then
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

        -- Update progress in the dialog
        if y % 10 == 0 then
            dlg:modify{ id = "status", text = string.format("Processing row %d of %d...", y + 1, height) }
        end
    end

    dlg:modify{ id = "status", text = "Done!" }
end

-- Show input dialog for colors
function createDialogue()
    local sprite = app.activeSprite
    if not sprite then
        app.alert("No active sprite!")
        return
    end

    local fgColor = app.fgColor -- Foreground color as default target color
    local bgColor = app.bgColor -- Background color as default outline color

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
    dlg:label{
        id = "status",
        text = "Ready"
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
                replaceColorBasedOnNeighbors(sprite, targetColor, outlineColor, dlg)
            end)
        end
    }
    dlg:button{
        id = "cancel",
        text = "Cancel"
    }
    dlg:show{ wait = false }
end

do
    createDialogue()
end
