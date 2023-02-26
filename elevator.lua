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

local function moveFor(time, direction)
    setDirection(direction)
    setMoving(true)
    sleep(time)
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
                moveFor(2.5, true)
                currFloor = 1
            end

        elseif currFloor == 1 then
            if rs.getInput(upIn) then
                moveFor(1.3, true) -- up
                currFloor = 2
            elseif rs.getInput(downIn) then
                moveFor(2.5, false) -- down
                currFloor = 0
            end

        elseif currFloor == 2 then
            if rs.getInput(upIn) then
                moveFor(1.5, true) -- up
                currFloor = 3
            elseif rs.getInput(downIn) then
                moveFor(1.1, false) -- down
                currFloor = 1
            end
        elseif currFloor == 3 then
            if rs.getInput(downIn) then
                moveFor(1.3, false) -- down
                currFloor = 2
            end
        end

        print("Current floor is: " .. currFloor)
    end
end
