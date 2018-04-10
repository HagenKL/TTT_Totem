CreateConVar("ttt_enhancements","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll TTT Enhancements aktiviert sein?"):GetBool()

include("tttenhancements/client/cl_equip_hud.lua")
print("TTT Enhancements successfully loaded!")
