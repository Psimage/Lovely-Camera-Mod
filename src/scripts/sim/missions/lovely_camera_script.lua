local cdefs = include( "client_defs" )
local array = include( "modules/array" )
local util = include( "modules/util" )
local simdefs = include( "sim/simdefs" )
local simquery = include( "sim/simquery" )
local level = include( "sim/level" )
local abilitydefs = include( "sim/abilitydefs" )
local mission_util = include( "sim/missions/mission_util" )
local SCRIPTS = include('client/story_scripts')
local rig_util = include( "gameplay/rig_util" )

---------------------------------------------------------------------------------------------
-- Main script.  init() gets executed as part of engine:init(), within the sim thread.

local lovely_camera_script = class()

function lovely_camera_script:init( scriptMgr )
	local sim = scriptMgr.sim

	sim:forEachUnit(
	function( cameraUnit )
		if cameraUnit:getTraits().mainframe_camera then
			cameraUnit:getTraits().mainframe_status = "inactive"
			cameraUnit:activate( sim )
		end
	end )

end

return lovely_camera_script
