misc_module = {
	loops = {}
}

function misc_module:runLoop(name, callback, waitt, ...) -- This is a function that runs a loop with a callback.
    if self.loops[name] == nil then
        if callback ~= nil then
            self:createLoop(name, callback, waitt, ...)
        end
    end

    self.loops[name].Running = true
    local succ, out = coroutine.resume(self.loops[name].Loop)
    if not succ then
        warn("Loop: " .. tostring(name) .. " ERROR: " .. tostring(out))
    end
end

function misc_module:createLoop(name, callback, waitt, ...)
    if self.loops[name] ~= nil then return end

		self.loops[name] = { }
		self.loops[name].Running = false
		self.loops[name].Destroy = false
		self.loops[name].Loop = coroutine.create(function(...)
			while true do
				if self.loops[name].Running then
					callback(...)
				end

				if self.loops[name].Destroy then
					break
				end

				if type(wait) == "userdata" then
					waitt:wait()
				else
					wait(waitt)
				end
			end
		end)
end

function misc_module:stopLoop(name) -- This is a function that stops a loop.
    if self.loops[name] ~= nil then
        self.loops[name].Running = false
    end
end
function misc_module:destroyLoop(name) -- This is a function that destroies a loop.
    if self.loops[name] ~= nil then
        self.loops[name].Destroy = true
    end
end


function misc_module:get_current_pos(client)
	if client.Character then 
    	return client.Character.HumanoidRootPart.Position
	end
end
function misc_module:is_visible(camera, client, p, ...)
    return #camera:GetPartsObscuringTarget({ p }, { camera, client.Character, workspace.Ignore, ... }) == 0
end
