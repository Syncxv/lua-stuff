gui_module = {}

syn_context_set(6)
local Roact = getrenv().require(game:GetService("CorePackages").Packages.Roact)
syn_context_set(6)

local coreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local DraggableBox = Roact.Component:extend("DraggableBox")

function DraggableBox:init()
    self:setState({
        dragStart = nil,
        dragOffset = nil,
        dragPosition = self.props.Position or UDim2.new(),
    })

    self.onInputEnded = function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:setState({
                dragStart = nil,
                dragOffset = nil,
            })
        end
    end

    self.drag = function(rbx, input)
        if self.state.isDragging and self.state.dragStart then
            local dragStart = self.state.dragStart
            local dragOffset = self.state.dragOffset
            local dragPosition = self.state.dragPosition or self.props.Position

            local newDragOffset = Vector2.new(input.Position.X - dragOffset.X, input.Position.Y - dragOffset.Y)


            dragPosition = UDim2.new(
                dragStart.X.Scale, dragStart.X.Offset + newDragOffset.X,
                dragStart.Y.Scale, dragStart.Y.Offset + newDragOffset.Y
            )
            self:setState({
                dragPosition = dragPosition,
            })
        end
    end
    
end

function DraggableBox:render()
    return Roact.createElement("Frame", {
        Position = self.state.dragPosition or self.props.Position,
        Size = self.props.Size,
        BackgroundColor3 = self.props.BackgroundColor3,
        BorderSizePixel = self.props.BorderSizePixel,
        BorderColor3 = self.props.BorderColor3,
        Draggable = true,
        [Roact.Event.InputBegan] = function(rbx, input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local dragStart = UDim2.new(0, rbx.AbsolutePosition.X, 0, rbx.AbsolutePosition.Y)
                self:setState({
                    isDragging =  true,
                    dragStart = dragStart,
                    dragOffset = input.Position,
                })
            end
        end,
        [Roact.Event.InputChanged] = function(rbx, input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                self.drag(rbx, input)
            end
        end
    }, self.props[Roact.Children])
end

function DraggableBox:didMount()
    UserInputService.InputEnded:Connect(self.onInputEnded)
end

function DraggableBox:willUnmount()
    UserInputService.InputEnded:Disconnect(self.onInputEnded)
end

local Clock = Roact.Component:extend("Clock")

function Clock:init()
    -- In init, we can use setState to set up our initial component state.
    self:setState({
        currentTime = 0
    })
end

-- This render function is almost completely unchanged from the first example.
function Clock:render()
    -- As a convention, we'll pull currentTime out of state right away.
    local currentTime = self.state.currentTime

    return Roact.createElement("ScreenGui", {}, {
        DraggableBox = Roact.createElement(DraggableBox, {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 200, 0, 100),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 2,
            BorderColor3 = Color3.new(0, 0, 0),
        }, {
            TextLabel = Roact.createElement("TextLabel", {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -20, 1, -20),
                BackgroundTransparency = 1,
                Text = "Drag me! " .. currentTime,
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 10,
            })
        })
    })
end

-- Set up our loop in didMount, so that it starts running when our
-- component is created.
function Clock:didMount()
    -- Set a value that we can change later to stop our loop
    self.running = true

    -- We don't want to block the main thread, so we spawn a new one!
    spawn(function()
        while self.running do
            -- Because we depend on the previous state, we use the function
            -- variant of setState. This will matter more when Roact gets
            -- asynchronous rendering!
            self:setState(function(state)
                return {
                    currentTime = state.currentTime + 1
                }
            end)

            wait(1)
        end
    end)
end

-- Stop the loop in willUnmount, so that our loop terminates when the
-- component is destroyed.
function Clock:willUnmount()
    self.running = false
end



function gui_module:init()
    -- Create our UI, which now runs on its own!
    local handle = Roact.mount(Roact.createElement(Clock), coreGui, "Clock UI")

    -- Later, we can destroy our UI and disconnect everything correctly.
    wait(10)
    Roact.unmount(handle)
end



function gui_module:init()
    -- Create our UI, which now runs on its own!
    local handle = Roact.mount(Roact.createElement(Clock), coreGui, "Clock UI")

    -- Later, we can destroy our UI and disconnect everything correctly.
    wait(10)
    Roact.unmount(handle)
end
