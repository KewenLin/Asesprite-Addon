function changeToCanvasPosition(dlg)
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
    local rect = image.bounds
    local blueValue
    for x = 0, image.width - 1 do
        blueValue = x % 2 == 0 and 2 or 253
        for y = 0, image.height - 1 do
            blueValue = blueValue == 2 and 253 or 2
            local pixelValue = image:getPixel(x, y)
            local alpha = app.pixelColor.rgbaA(pixelValue)
            if alpha >= 1 then
                local color = Color(x+ cel.position.x, y + cel.position.y, blueValue, 255)
                image:drawPixel(x, y, color)
            end
        end
    end
    dlg:modify{ id= "status",
            text= "Done" }
end

function isInsideRectangle(x, y, rectX, rectY, rectWidth, rectHeight)
    local rectRight = rectX + rectWidth
    local rectBottom = rectY + rectHeight

    return x >= rectX and x <= rectRight and y >= rectY and y <= rectBottom
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
            changeToCanvasPosition(dlg)
        end
    }
    dlg:
    label{ 
        id= "status",
        text= "No action" 
    }
    dlg:
    slider{ 
        id= "Value1",
        label= "Value1",
        min= 0,
        max= 255,
        value= 0
    }
    dlg:
    slider{ 
        id= "Value2",
        label= "Value2",
        min= 0,
        max= 255,
        value= 255
    }
    dlg:show{ 
        wait=false 
    }
end

do
  createDialogue()
end
