-- Source: https://github.com/MysteryPancake/GMod-Binding/
bind = {}

local tablename = "totem_bindings"

local Bindings = {}
local Registry = {}

--[[----------------------------

 	INTERNAL FUNCTIONS

-------------------------]]-----
local function DBCreateTable()
	local tblname = tablename
	if !(sql.TableExists(tblname)) then
    	query = "CREATE TABLE " .. tblname .. " (guid TEXT, name TEXT, button TEXT)"
		result = sql.Query(query)
		if result == false then return false end
		return true
	else
		return true
	end
end

local function SaveBinding(name, button)
	if DBCreateTable() then
		query = "INSERT INTO totem_bindings VALUES('" .. LocalPlayer():SteamID() .. "','" .. name .. "','" .. button .. "')"
	    result = sql.Query(query)
		print("Saved binding...")
	end
end

local function DBRemoveBinding(name, button)
	print("Deleting key from DB")
	if DBCreateTable() then
		query = "DELETE FROM totem_bindings WHERE guid = '" .. LocalPlayer():SteamID() .. "' AND name = '" .. name .. "' AND button = '" .. button .. "'"
	    result = sql.Query(query)
		print("Removed binding...")
	end
end

local function LoadBindings()
	if DBCreateTable() then
		query = "SELECT * FROM totem_bindings WHERE guid = '" .. LocalPlayer():SteamID() .. "'"
	    result = sql.Query(query)
		if istable(result) then
			for _, tbl in pairs(result) do
				if Bindings[tbl["button"]] == nil then Bindings[tbl["button"]] = {} end
				table.insert(Bindings[tbl["button"]], tbl["name"])
			end
			print("Loaded bindings...")
		end
	end
end

--[[---------------------------------------------------------

			END INTERNAL FUNCTIONS

--]]----------------------------------------

--[[---------------------------------------------------------
    GetTable()
    Returns a table of all the bindings.
-----------------------------------------------------------]]
function bind.GetTable() return Bindings end

--[[---------------------------------------------------------
    Register( any identifier, function func )
    Register a function to run when the button for a specific binding is pressed.
-----------------------------------------------------------]]
function bind.Register( name, func )

	if !isfunction( func ) then return end

	Registry[ name ] = func

end

--[[---------------------------------------------------------
    Add( number button, any identifier, bool persistent )
    Add a binding to run when the button is pressed.
-----------------------------------------------------------]]
function bind.Add( btn, name, pers )

	if name and not name == "" then return end
	if !isnumber( btn ) then return end

	if Bindings[ btn ] == nil then
		Bindings[ btn ] = {}
	end

	table.insert(Bindings[ btn ], name)
	if(pers) then
		SaveBinding( name, btn )
	end
end

--[[---------------------------------------------------------
    Find( any identifier )
    Find buttons associated with a specific binding and returns
	the button. Returns KEY_NONE if no button is found.
-----------------------------------------------------------]]
function bind.Find( name )
	for btn, tbl in pairs( Bindings ) do
		for _, id in pairs ( tbl ) do
			if id == name then return btn end
		end
	end
	return KEY_NONE
end

--[[---------------------------------------------------------
    Remove( number button, any identifier )
    Removes the binding with the given identifier.
-----------------------------------------------------------]]
function bind.Remove( btn, name )
	print("Attempt to remove binding "..name.." on button id "..tonumber(btn))
	DBRemoveBinding( name, btn ) -- Still try to delete from DB
	if not Bindings[ btn ] then return end
	print("removing")
	for i, v in pairs(Bindings[ btn ]) do
		if v == name then Bindings[ btn ][i] = nil end
	end


end

-- INIT
hook.Add("InitPostEntity", "TTTLoadBindings", LoadBindings)

local FirstPressed = {}

hook.Add( "Think", "CallBindings", function()
	for btn, tbl in pairs( Bindings ) do
		local cache = input.IsButtonDown( btn )
		if cache and FirstPressed[ btn ] then
			for _, name in pairs(tbl) do
				if isfunction(Registry[name]) then Registry[name]() end
			end
		end
		FirstPressed[ btn ] = !cache
	end
end )
