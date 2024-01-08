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
    local rect = image.bounds
    local blueValue
    for x = 0, sprite.width - 1 do
        blueValue = x % 2 == 0 and 255 or 0
        for y = 0, sprite.height - 1 do
            if isInsideRectangle(x,y,rect.x,rect.y,rect.w,rect.h) then
                local pixelValue = image:getPixel(x, y)
                local alpha = app.pixelColor.rgbaA(pixelValue)
                blueValue = blueValue == 0 and 255 or 0
                if alpha >= 1 then
                    local color = Color(x, y, blueValue, 255)
                    image:drawPixel(x, y, color)
                end
            end
        end
    end
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
            changeToCanvasPosition()
            dlg:close()
        end
    }
    dlg:show{ 
        wait=false 
    }
end

do
  createDialogue()
end
