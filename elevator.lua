local directionOut = "back" -- DOWN = true, UP = false
local movingOut = "left" -- STOPPED = true, MOVING = false
local upIn = "top" -- Elevator go up button
local downIn = "right" -- Elevator go down button
local resetIn = "front"

local currFloor = 0
local inMotion = false

local function setMoving(isMoving)
    inMotion = isMoving
    rs.setOutput(movingOut, not isMoving)
end

local function setDirection(isGoingUp)
    rs.setOutput(directionOut, not isGoingUp)
end

local function reset()
    rs.setOutput(directionOut, true) -- Direction DOWN
    setMoving(true)
    sleep(10)
    currFloor = 0
    setMoving(false)
end

print("Starting elevator")

print("Resetting...")

reset()

print("Reset complete")



while true do
    os.pullEvent("redstone")

    if not inMotion then
        if rs.getInput(resetIn) then
            print("Manual Reset")
            reset()
            print("Reset complete")
        end

        if currFloor == 0 then
            if rs.getInput(upIn) then
                setDirection(true)
                setMoving(true)
                sleep(2.5)
                setMoving(false)
                currFloor = 1
            end

        elseif currFloor == 1 then
            if rs.getInput(upIn) then
                setDirection(true) -- up
                setMoving(true)
                sleep(1.3)
                setMoving(false)
                currFloor = 2
            elseif rs.getInput(downIn) then
                setDirection(false) -- down
                setMoving(true)
                sleep(2.5)
                setMoving(false)
                currFloor = 0
            end

        elseif currFloor == 2 then
            if rs.getInput(upIn) then
                setDirection(true) -- up
                setMoving(true)
                sleep(1.5)
                setMoving(false)
                currFloor = 3
            elseif rs.getInput(downIn) then
                setDirection(false) -- down
                setMoving(true)
                sleep(1.1)
                setMoving(false)
                currFloor = 1
            end
        elseif currFloor == 3 then
            if rs.getInput(downIn) then
                setDirection(false) -- down
                setMoving(true)
                sleep(1.3)
                setMoving(false)
                currFloor = 2
            end
        end

        print("Current floor is: " .. currFloor)
    end
end
