local processName = "Warframe.x64.exe"
local dllPath = "C:\\Users\\Aruldev\\source\\repos\\FrameWarHEHEHE\\build\\FrameWarHEHEHE.dll"

function injectDLL(process, dll)
    local dllBytes = readBytes(dll, #dll+1, true)
    if dllBytes then
        local dllAddress = allocateMemory(#dllBytes)
        if dllAddress then
            writeBytes(dllAddress, dllBytes)
            local threadId = createThread(dllAddress)
            if threadId then
                return true
            else
                showMessage("Failed to create remote thread")
            end
        else
            showMessage("Failed to allocate memory")
        end
    else
        showMessage("Failed to read DLL")
    end

    return false
end
local autoAttachTimer = nil ---- variable to hold timer object
local autoAttachTimerInterval = 1000 ---- Timer intervals are in milliseconds
local autoAttachTimerTicks = 0 ---- variable to count number of times the timer has run
local autoAttachTimerTickMax = 5000 ---- Set to zero to disable ticks max
local function autoAttachTimer_tick(timer) ---- Timer tick call back
        ---- Destroy timer if max ticks is reached
	if autoAttachTimerTickMax > 0 and autoAttachTimerTicks >= autoAttachTimerTickMax then
		timer.destroy()
	end
        ---- Check if process is running
    local process = getProcessIDFromProcessName(processName)
	if process ~= nil then
		timer.destroy() ---- Destroy timer
		openProcess(processName) ---- Open the process
        if not injectDLL(process, dllPath) then
            showMessage("DLL injection failed")
        end
	end
	autoAttachTimerTicks = autoAttachTimerTicks + 1 ---- Increase ticks
end
autoAttachTimer = createTimer(getMainForm()) ---- Create timer with the main form as it's parent
autoAttachTimer.Interval = autoAttachTimerInterval ---- Set timer interval
autoAttachTimer.OnTimer = autoAttachTimer_tick ---- Set timer tick call back