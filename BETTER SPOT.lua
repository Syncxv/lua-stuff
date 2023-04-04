syn.run_on_actor(getactors()[1], [[
    print("hi")
                local shared = getrenv().shared
          		local u7 = shared.require("ReplicationInterface")
          		
                local u6 = shared.require("GameClock");
                          		
                local u1 = shared.require("PlayerStatusInterface");
                          		
                local run_service = game:GetService("RunService")

                local hehe = function()
                    u7.operateOnAllEntries(function(p3, p4) 
                        local v13 = u1.getEntry(p3);
                        if not v13 then
                            print("welp")
                            return;
                        end
                        print('------', p3);
                                for i,v in pairs(v13) do print(i) end
                        v13.lastSightedTime = u6.getTime() + 10000
                        v13.isSpotted = true
                    end);
                end
                

                run_service.RenderStepped:Connect(function()
                    -- sleep 3 seconds
                    wait(3)
                    hehe()
                end)

    ]])

