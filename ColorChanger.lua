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
  
    for x = 0, image.width - 1 do
        for y = 0, image.height - 1 do
            local pixelValue = image:getPixel(x, y)
            local alpha = app.pixelColor.rgbaA(pixelValue)
            if alpha >= 1 then
                local color = Color(x, y, 100, 255)
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
    dlg:show{ 
        wait=false 
    }
end

do
  createDialogue()
end
