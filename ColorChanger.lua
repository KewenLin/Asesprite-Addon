function changeToCanvasPosition()
    local sprite = app.activeSprite
    if sprite == nil then
        return
    end

    local cel = app.activeCel
    if cel == nil then
        return
    end

    local image = cel.image
  
    for y = 0, image.height - 1 do
        for x = 0, image.width - 1 do
            local pixel = image:getPixel(x, y)
            if pixel.alpha >= 1 then
                local r = x
                local g = y
                local color = Color(r, g, 0, 255)
                image:drawPixel(x, y, color)
            end
        end
    end
end

function createDialogue()
    local dlg
    dlg =
    Dialog {
    title = "Color As Position"
    }
    
    dlg:
    button {
        id = "change",
        text = "Change Color",
        onclick = function()
            changeToCanvasPosition()
        end
    }
end

createDialogue()
