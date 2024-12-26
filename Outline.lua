-- Function to replace colors based on neighbors and selection area (or whole sprite if no selection)
function replaceColorBasedOnNeighbors(dlg)
    dlg:modify{ id = "status", text = "Processing..." }

    local sprite = app.sprite
    if not sprite then
        app.alert("No active sprite!")
        return
    end
    
    local targetColor = dlg.data.targetColor
    local outlineColor = dlg.data.outlineColor
    
    local cel = app.cel
    if not cel then
        dlg:modify{ id = "status", text = "No active cel!" }
        return
    end

    local image = cel.image
    local selection = sprite.selection
    local selectionBounds

    -- If there's a selection, use its bounds; otherwise, use the whole sprite
    if not selection.isEmpty then
        selectionBounds = selection.bounds
    else
        -- Use the entire sprite if there's no selection
        selectionBounds = {x = 0, y = 0, width = image.width, height = image.height}
    end

    -- Loop through the image pixels within the selection bounds (or entire sprite)
    for y = selectionBounds.y, selectionBounds.y + selectionBounds.height - 1 do
        for x = selectionBounds.x, selectionBounds.x + selectionBounds.width - 1 do
            -- Check if the pixel is inside the selection region
            if selection:contains(x, y) then
                local currentColor = image:getPixel(x, y)
                if currentColor == targetColor then
                    -- Check the 8 neighbors directly
                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            if not (dx == 0 and dy == 0) then
                                local neighborColor = image:getPixel(x + dx, y + dy)
                                if neighborColor and neighborColor ~= targetColor then
                                    image:drawPixel(x + dx, y + dy, outlineColor)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    dlg:modify{ id = "status", text = "Done!" }
end

-- Function to create the dialog and initiate the process
function createDialogue()
    local dlg = Dialog("Outline Color Tool")
    dlg:color{
        id = "targetColor",
        label = "Target Color",
        color = app.fgColor,
    }
    dlg:color{
        id = "outlineColor",
        label = "Outline Color",
        color = app.bgColor,
    }
    dlg:label{
        id = "status",
        text = "No action"
    }
    dlg:button{
        id = "ok",
        text = "OK",
        focus = true,
        onclick = function()
            app.transaction(function()
                replaceColorBasedOnNeighbors(dlg)
            end)
        end
    }
    dlg:button{
        id = "cancel",
        text = "Cancel"
    }
    dlg:show{ wait = true }
end

do
    createDialogue()
end
