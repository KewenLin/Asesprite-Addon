
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
            if pixel.alpha == 255 then
                local color = getColorByGridPosition(x, y)
                image:drawPixel(x, y, color)
            end
        end
    end

end

do
  changeToCanvasPosition()
end
