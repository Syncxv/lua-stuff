local data = {}

		local what = getgc(true)
		for i, v in pairs(what) do
				 if typeof(v) == "table" then
       				for j, va in pairs(v) do
       						table.insert(data, j)
       				end
    			end
		end
		
		setclipboard(tostring(data))