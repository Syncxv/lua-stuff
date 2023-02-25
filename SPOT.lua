for _, v in pairs(getactors()) do --phantom forces out here using actors
    if tostring(v) == "lol" then --actor named lul
        syn.run_on_actor(v, [[
          		local shared = getrenv().shared
          		local u7 = shared.require("ReplicationInterface")
          		
local u6 = shared.require("GameClock");
          		
local u1 = shared.require("PlayerStatusInterface");
				local netwokr = shared.require("network");
          		
u7.operateOnAllEntries(function(p3, p4)
          		
local u12  = {}
		if true then
			if true then
				local v13 = u1.getEntry(p3);
				if not v13 then
					warn("PlayerStatusInterface: No status found for", p3, "on spot");
					return;
				end;
				v13.lastSightedTime = u11;
				v13.isSpotted = true;
				table.insert(u12, p3);
			end;
		end;
	end);
	network:send("spotplayers", u12, u11);
          ]])
    end
end