totem_info_bindings_key = "info_bindings"
local tblname = "totem_data"

function DBCreateTable()
	if !(sql.TableExists(tblname)) then
    	query = "CREATE TABLE " .. tblname .. " (guid TEXT, key TEXT, value TEXT)"
		result = sql.Query(query)
		if result == false then return false end
		return true
	else
		return true
	end
end

function DBInsertData(key, value)
	if DBCreateTable() then
		query = "REPLACE INTO " .. tblname .. " VALUES('" .. LocalPlayer():SteamID() .. "','" .. key .. "','" .. value .. "')"
	    result = sql.Query(query)
		print("Saved data...")
	end
end

function DBRemoveData(key)
	print("Deleting key from DB")
	if DBCreateTable() then
		query = "DELETE FROM " .. tblname .. " WHERE guid = '" .. LocalPlayer():SteamID() .. "' AND key = '" .. key .. "'"
	    result = sql.Query(query)
		print("Removed data...")
	end
end

function DBLoadValue(key)
	if DBCreateTable() then
		query = "SELECT * FROM " .. tblname .. " WHERE guid = '" .. LocalPlayer():SteamID() .. "' AND key = '" .. key .. "'"
	    result = sql.Query(query)
		if result == false then return nil end
		if istable(result) then
			local tr = {}
			for _, tbl in pairs(result) do
				table.insert(tr, tbl)
			end
			print("Loaded bindings...")
			--PrintTable(tr)
			if tr[1] then
				print(tr[1]["key"] .. " " .. tr[1]["value"])
				return tr[1]["value"]
			end
			return tr[1];
		end
		print("Loaded bindings...")
		return result
	end
	return nil
end
