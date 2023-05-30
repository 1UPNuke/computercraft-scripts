STRIP_LENGTH = 16
STRIP_COUNT  = 16
STRIP_GAP    = 2
TORCH_GAP    = 11

args = {...}
if args[1] ~= nil and args[1] > 0 then STRIP_LENGTH = args[1] end
if args[2] ~= nil and args[2] > 0 then STRIP_COUNT = args[2] end
if args[3] ~= nil and args[3] > 0 then STRIP_GAP = args[3] end
if args[4] ~= nil and args[4] > 0 then TORCH_GAP = args[4] end

function main()
    if not hasFuel() then return end
    if not hasTorches() then return end

    turtle.turnRight()

    for i=1, STRIP_COUNT do
        dig1by2(STRIP_LENGTH)
        reverseBack(STRIP_LENGTH)
        if i < STRIP_COUNT then
            strafeLeft(STRIP_GAP + 1)
        end
    end

    turtle.turnRight()
    moveForward((STRIP_COUNT + 1) * STRIP_GAP)

    depositToChest()
end

function hasFuel()
    local requiredFuel = STRIP_COUNT * (STRIP_LENGTH * 2 + STRIP_GAP)
    if turtle.getFuelLevel() < requiredFuel then
        print("Not enough fuel, please refuel")
        return false
    end
    return true
end

function hasTorches()
    turtle.select(1)

    if turtle.getItemCount() <= 0 then
        print("Please place torches in the first slot.")
        return false
    end

    local item = turtle.getItemDetail()

    if item.name ~= "minecraft:torch" then
        print("Please place torches in the first slot.")
        return false
    end

    local torchesRequired = STRIP_LENGTH * STRIP_COUNT / TORCH_GAP

    if torchesRequired > 64 then
        print("Torches required is greater than a stack")
        return false
    end
    if item.count < torchesRequired then
        print("Not enough torches")
        return false
    end

    return true
end

function dig1by2(distance)
    for i=0, distance-1 do
        keepDigging()
        turtle.forward()
        keepDiggingUp()
        if i%TORCH_GAP == 0 then
            placeTorch()
            discardCobble()
        end
    end
end

function moveForward(distance)
    for i=1, distance do
        turtle.forward()
    end
end

function reverseBack(distance)
    turtle.turnLeft()
    turtle.turnLeft()
    moveForward(distance)
    turtle.turnRight()
    turtle.turnRight()
end

function placeTorch()
    turtle.turnLeft()
    turtle.select(1)
    turtle.placeUp()
    turtle.turnRight()
end

function strafeLeft(distance)
    turtle.turnLeft()
    dig1by2(distance)
    turtle.turnRight()
end

function depositToChest()
    local success, data = turtle.inspect()
    if success then
        if data.name ~= "minecraft:chest" and data.name ~= "minecraft:trapped_chest" then
            print("No chest found, stopping")
            return
        end
        for i=1, 16 do
            turtle.select(i)
            turtle.drop()
        end
    else
        print("No chest found, stopping")
        return
    end
end

function discardCobble()
    for i=1, 16 do
        turtle.select(i)
        if turtle.getItemCount() > 0 then
            local item = turtle.getItemDetail()
            if item.name == "minecraft:cobblestone" then
                turtle.drop()
            end
        end
    end
end

-- Use these functions to avoid complications from gravel
function keepDigging()
    while turtle.detect() do
        turtle.dig()
        sleep(1)
    end
end
function keepDiggingUp()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(1)
    end
end

main()
