-- Function to replace colors based on neighbors and selection area (or whole sprite if no selection)
function replaceColorBasedOnNeighbors(dlg)
    dlg:modify{ id = "status", text = "Processing..." }

    local sprite = app.sprite
    if not sprite then
        dlg:modify{ id = "status", text = "No active sprite!" }
        return
    end
    
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
            local currentColor = image:getPixel(x, y)
            if currentColor == targetColor then
                local neighbors = {
                    {dx = -1, dy = 0},  -- left
                    {dx = 1, dy = 0},   -- right
                    {dx = 0, dy = -1},  -- up
                    {dx = 0, dy = 1},   -- down
                }

                for _, neighbor in ipairs(neighbors) do
                    local nx, ny = x + neighbor.dx, y + neighbor.dy
                    if selection:contains(nx, ny) or selection.isEmpty then
                        local neighborColor = image:getPixel(nx, ny)
                        if neighborColor and neighborColor ~= targetColor then
                            image:drawPixel(nx, ny, outlineColor)
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
    dlg:show{ wait = false }
end

do
    createDialogue()
end
