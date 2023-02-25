
    local function find_by_name(t, name) for _, v in pairs(t) do if v.name == name then return v end end end
    local actor = find_by_name(getactors(), 'lol')
    syn.run_on_actor(actor, [[
    print("hi")
    local shared = getrenv().shared
    function PrintTable(tbl,key,queue)
	-- tbl is a table or value in a table
	-- key is the number or position in the table
	-- queue is how far a value is in a table
	local function FormatBetween(formatBetween,stringTable)
		local strToReturn
		for k,n in pairs(stringTable) do
			strToReturn = (strToReturn or "") .. (k == 1 and "" or formatBetween) .. n
		end
		return strToReturn
	end
	
	queue = queue or 1
	if type(tbl) == "table" then
		for k,n in pairs(tbl) do
			PrintTable(n,k,queue + 1)
		end
	else
		local addOn
		local formatTable = {}
		for i = 1,queue - 1 do
			table.insert(formatTable,"	")
		end
		if queue > 1 then
			table.insert(formatTable,"►")
		end
		addOn = FormatBetween(" ",formatTable) or ""
		if key then print(addOn,'["' .. key .. '"] =',tbl) else print(addOn,tbl) end
	end
end

    local u17 = shared.require("PlayerDataUtils");
    local playerDataStore = shared.require("PlayerDataStoreClient");
PrintTable(u17)
-- u17.tagCost = 10;
    -- local player = playerDataStore.getPlayerData()
    u17.ownsWeapon = function()
    return true
    end
    -- -- for i,v in pairs(u17) do print(i) end
    
    -- u17.getPlayerRank = function()
    -- return 999999999
    -- end

    ]])