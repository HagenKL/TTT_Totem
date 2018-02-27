-------------------------------------------------------------------------------
--    ENHANCED NOTIFICATION FRAMEWORK
--    Copyright (C) 2017 saibotk (tkindanight)
-------------------------------------------------------------------------------
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------

local ENHANCED_NOTIFICATIONS = {}

-------------------------------------------------------------------------------
-- Signature:   GetVersion()
-- Description: Returns the version of Enhanced Notification Framework
-- Returns:     String
-------------------------------------------------------------------------------
function ENHANCED_NOTIFICATIONS:GetVersion()
    return "1.2.0"
end

-- Create ConVars for configuration
-- CreateConVar("enf_settings_lifetime","5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "How long should a notification be active?")

return ENHANCED_NOTIFICATIONS
