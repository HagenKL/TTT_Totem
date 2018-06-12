AddCSLuaFile("tttenhancements/cl_init.lua")
--AddCSLuaFile("shared.lua")
AddCSLuaFile("autorun/ttt_enhancements_autorun.lua")

// Clientside code
AddCSLuaFile("tttenhancements/client/cl_equip_hud.lua")

// Resources


//Convars
local ttt_enhancements = CreateConVar("ttt_enhancements","1", {FCVAR_ARCHIVE}, "Soll TTT Enhancements aktiviert sein?"):GetBool()

print("TTT Enhancements successfully loaded!")
