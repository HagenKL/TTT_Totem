-- Short and sweet
if SERVER then
	include( "vote/init.lua" )
else
	include( "vote/cl_init.lua" )
end
include("vote/shared.lua")
