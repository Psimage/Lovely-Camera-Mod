----------------------------------------------------------------
-- Copyright (c) 2012 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local serverdefs = include( "modules/serverdefs" )
local util = include( "modules/util" )
local weighted_list = include( "modules/weighted_list" )
local mathutil = include( "modules/mathutil" )
local array = include( "modules/array" )
local rand = include( "modules/rand" )
local cdefs = include( "client_defs" )
local simdefs = include( "sim/simdefs" )
local simquery = include( "sim/simquery" )
local mazegen = include( "sim/mazegen" )
local roomgen = include( "sim/roomgen" )
local prefabs = include( "sim/prefabs" )
local unitdefs = include( "sim/unitdefs" )
local procgen_context = include( "sim/procgen_context" )
local npc_abilities = include( "sim/abilities/npc_abilities" )
local version = include( "modules/version" )

------------------------------------------------------------------------
-- Local helpers

-- these are the old variabls used, but have been replaced with ordered lists
local CAMERA_DRONE_DEFAULT = {camera_drone = 100  } 
local FTM_THREAT_DEFAULT = { ftm_guard_tier_2 = 50, barrier_guard = 50, ftm_grenade_guard = 50 }
local FTM_GUARD_DEFAULT = { ftm_guard = 100 }
local PLASTECH_THREAT_DEFAULT = {  plastek_guard_tier2 = 50, plastek_recapture_guard = 1000 }
local PLASTECH_THREAT_0_17_5_DEFAULT = {  plastek_guard_tier2 = 50, plastek_recapture_guard = 50 }
local PLASTECH_GUARD_DEFAULT = { plastek_guard = 100 }
local KO_THREAT_DEFAULT = { ko_specops = 50, ko_guard_heavy = 50, ko_guard_tier2 = 50, ko_grenade_guard = 50 }
local KO_GUARD_DEFAULT = { ko_guard = 100 }
local SANKAKU_THREAT_DEFAULT = { null_drone = 25, drone_akuma = 25, drone_tier2 = 25, sankaku_guard_tier_2 = 25 }
local SANKAKU_HUMAN_THREAT_DEFAULT = { sankaku_guard_tier_2 = 100 }
local SANKAKU_GUARD_DEFAULT = { sankaku_guard = 100, drone = 100 }
local SANKAKU_HUMAN_GUARD_DEFAULT = { sankaku_guard = 100 }
local OMNI_GUARD_DEFAULT = { omni_crier = 50, omni_protector = 50, omni_soldier = 50 }

local CAMERA_DRONE = {}
local FTM_THREAT = {}
local FTM_GUARD = {}
local PLASTECH_THREAT = {}
local PLASTECH_THREAT_0_17_5 = {}
local PLASTECH_GUARD = {}
local KO_THREAT = {}
local KO_GUARD = {}
local SANKAKU_THREAT = {}
local SANKAKU_HUMAN_THREAT = {}
local SANKAKU_GUARD = {}
local SANKAKU_HUMAN_GUARD = {}
local OMNI_GUARD = {}


-- the new ordered list variables
local CAMERA_DRONE_DEFAULT_FIX = { {"camera_drone",100} }
local OMNI_GUARD_DEFAULT_FIX = { {"omni_crier",50}, {"omni_protector",50}, {"omni_soldier",50} }

local CAMERA_DRONE_FIX = {}
local OMNI_GUARD_FIX = {}

local FTM={
    THREAT_DEFAULT_FIX = { {"ftm_guard_tier_2",50}, {"barrier_guard",50}, {"ftm_grenade_guard",50} },
    GUARD_DEFAULT_FIX = { {"ftm_guard",100} },
    LVL2_DEFAULT = {},
    THREAT_FIX = {},
    GUARD_FIX = {},
    LVL2 ={},
    PREFABS_DEFAULT = {{prefab="scanner", num=1 }},
    PREFABS = {},    
}

local PLASTECH ={
    THREAT_DEFAULT_FIX = {  {"plastek_guard_tier2",50}, {"plastek_recapture_guard",50} },
    GUARD_DEFAULT_FIX = { {"plastek_guard",100} },
    LVL2_DEFAULT = {},
    THREAT_FIX = {},
    GUARD_FIX = {},
    LVL2 = {},
    PREFABS_DEFAULT = {},
    PREFABS = {},    
}
local KO ={
    THREAT_DEFAULT_FIX = { {"ko_specops",50}, {"ko_guard_heavy",50}, {"ko_guard_tier2",50}, {"ko_grenade_guard",50} },
    GUARD_DEFAULT_FIX = { {"ko_guard",100} },
    LVL2_DEFAULT = {},
    THREAT_FIX = {},
    GUARD_FIX = {},
    LVL2 = {},
    PREFABS_DEFAULT = {},
    PREFABS = {},    
}
local SANKAKU ={
    THREAT_DEFAULT_FIX = { {"null_drone",25}, {"drone_akuma",25}, {"drone_tier2",25}, {"sankaku_guard_tier_2",25} },
    HUMAN_THREAT_DEFAULT_FIX = { {"sankaku_guard_tier_2",100} },
    GUARD_DEFAULT_FIX = { {"sankaku_guard",100}, {"drone",100} },
    HUMAN_GUARD_DEFAULT_FIX = { {"sankaku_guard",100} },
    LVL2_DEFAULT = {},
    THREAT_FIX = {},
    HUMAN_THREAT_FIX = {},
    GUARD_FIX = {},
    HUMAN_GUARD_FIX = {},
    LVL2 = {},
    PREFABS_DEFAULT = {},
    PREFABS = {},    
}

local OMNI ={
    PREFABS_DEFAULT = {},
    PREFABS={},
}

local SIDEMISSIONS_DEFAULT = {}
local SIDEMISSIONS = {}

local OMNI_DAEMONS = {}
for i,program in ipairs(serverdefs.OMNI_PROGRAM_LIST)do
	OMNI_DAEMONS[program] = 1
end

local OMNI_DAEMONS_EASY = {}
for i,program in ipairs(serverdefs.OMNI_PROGRAM_LIST_EASY)do
	OMNI_DAEMONS_EASY[program] = 1
end

local DAEMONS = {}
for i,program in ipairs(serverdefs.PROGRAM_LIST)do
	DAEMONS[program] = 1
end

local EXTRA_CAMERAS = 
{
	[1] = 0, 
	[2] = 0, 
	[3] = 1, 
	[4] = 3,
	[5] = 3,
	[6] = 3, 
	[7] = 4, 
	[8] = 4, 
	[9] = 4, 
	[10] = 4, 

    [11] = 4, 
    [12] = 4, 
    [13] = 4, 
    [14] = 4,
    [15] = 4,
    [16] = 5, 
    [17] = 5, 
    [18] = 5, 
    [19] = 5, 
    [20] = 5,     
}

local TURRET_NUMBERS = 
{
	[1] = 0, 
	[2] = 1, 
	[3] = 2, 
	[4] = 3,
	[5] = 3,
	[6] = 3, 
	[7] = 4, 
	[8] = 4, 
	[9] = 4, 
	[10] = 4, 

    [11] = 4, 
    [12] = 4, 
    [13] = 4, 
    [14] = 4,
    [15] = 4,
    [16] = 5, 
    [17] = 5, 
    [18] = 5, 
    [19] = 5, 
    [20] = 5,     
} 


local function addWorldPrefabs(world )
	local prefabt = include( string.format( "sim/prefabs/%s/prefabt", world  ))
	serverdefs.addWorldPrefabts(world,prefabt)
end

function isVersion( params, v1 )
    -- Is the mission parameter version at least v1?
    return version.isVersionOrHigher( params.missionVersion or "", v1 )
end

local function canGuardSpawn( cxt, x, y )
	local cell = cxt.board[y][x]
	if cell.tileIndex == nil or cell.tileIndex == cdefs.TILE_SOLID or cell.exitID or cell.cell ~= nil or cell.impass then
		return false
	end

	if cell.tags and array.find( cell.tags, "noguard" ) then
		return false
	end

	for i, unit in ipairs( cxt.units ) do
		if unit.x == x and unit.y == y then
			return false
		end
	end

	-- No units already occupy this space.  Ok!
	return true
end

local function canSpawnThreat( cxt, zoneThreats, room )
    local beginnerPatrols = cxt.params.difficultyOptions.beginnerPatrols
    if room.tags.entry then
        return false -- Never spawn threats in entry room.
    end
    if beginnerPatrols and zoneThreats ~= nil and #zoneThreats > 0 then
        return false
    end

    return true
end

local function findThreatRoom( cxt, zoneThreats )
    local beginnerPatrols = cxt.params.difficultyOptions.beginnerPatrols
    local rooms = util.weighted_list()
    for i, room in ipairs( cxt.rooms ) do
        if canSpawnThreat( cxt, zoneThreats[ room.zoneID ], room ) then
            if beginnerPatrols then
                local totalDist = 1
                local cx, cy = (room.xmin + room.xmax)/2, (room.ymin + room.ymax)/2
                for zoneID, units in pairs( zoneThreats ) do
                    for j, threatUnit in ipairs( units ) do
                        totalDist = totalDist + mathutil.dist2d( threatUnit.x, threatUnit.y, cx, cy )
                    end
                end
                rooms:addChoice( room, totalDist )
            else
                rooms:addChoice( room, 1 )
            end
        end
    end

    if beginnerPatrols then
        return rooms:removeHighest()
    else
        return rooms:getChoice( cxt.rnd:nextInt( 1, rooms:getTotalWeight() ) )
    end
end

local function findGuardSpawn( cxt, zoneThreats, room )
    local MIN_THREAT_DIST = 2 -- Min cell distance between threats, so they aren't too close
    local cells = {}
    for _, rect in ipairs(room.rects) do
        for x = rect.x0, rect.x1 do
            for y = rect.y0, rect.y1 do
                local minThreatDist = math.huge
                if zoneThreats then
                    for i, threatUnit in ipairs(zoneThreats) do
                        minThreatDist = math.min( minThreatDist, mathutil.dist2d( x, y, threatUnit.x, threatUnit.y ))
                    end
                end
                if minThreatDist > MIN_THREAT_DIST and canGuardSpawn( cxt, x, y ) then
                    table.insert( cells, x )
                    table.insert( cells, y )
                end
            end
        end
    end

    if #cells > 0 then
        local i = cxt.rnd:nextInt( 1, #cells / 2 )
        return cells[2 * i - 1], cells[2 * i]
    end
end

local function isGuard( unit )
	local templateUnitData = unitdefs.lookupTemplate( unit.template )
	return templateUnitData.traits.isGuard
end

local function canCarryPasscards( unit )
	local templateUnitData = unitdefs.lookupTemplate( unit.template )
	return templateUnitData.traits.isGuard and not templateUnitData.traits.isDrone
end

local function hasTag( unit, tag )
	if unit.unitData and unit.unitData.tags then
		if array.find( unit.unitData.tags, tag ) ~= nil then
			return true
		end
	end

	local templateUnitData = unitdefs.lookupTemplate( unit.template )
	assert( templateUnitData, unit.template )
	return templateUnitData.tags and array.find( templateUnitData.tags, tag ) ~= nil
end

local function getCameraNumbers(params, difficulty)

	local cameraNum = 3 + EXTRA_CAMERAS[difficulty]

	
	local alarmList = params.difficultyOptions.alarmTypes
	if params.missionEvents and params.missionEvents.advancedAlarm then
		if params.difficultyOptions.alarmTypes == "EASY" then
			alarmList = "ADVANCED_EASY"
		elseif params.difficultyOptions.alarmTypes == "NORMAL" then
			alarmList = "ADVANCED_NORMAL"
		end
    end

	for i,alarm in ipairs( simdefs.ALARM_TYPES[alarmList] ) do
		if alarm == "cameras" then 
			cameraNum= cameraNum + simdefs.TRACKER_CAMERAS[i]
		end
	end

	return cameraNum
end

local function finalizeGuard( cxt, unit )
	return unit
end

local function spawnUnits( cxt, templates )

    local zoneThreats = {} -- map of zoneID to threats.
	
    for i, template in ipairs(templates) do
        local room, attempts = nil, 0
        local x, y = nil, nil
        while (x == nil or y == nil) and attempts < 20 do
            room = findThreatRoom( cxt, zoneThreats )
            if room then
                x, y = findGuardSpawn( cxt, zoneThreats[ room.zoneID ], room )
            end
            attempts = attempts + 1
        end
		if x and y then
            local templateName = template
			local unit =
			{
				x = x,
				y = y,
				template = templateName,
			}

            if isGuard( unit ) then
				unit = finalizeGuard( cxt, unit )
			end
            if unit then
                if zoneThreats[ room.zoneID ] == nil then
                    zoneThreats[ room.zoneID ] = {}
                end
                table.insert( zoneThreats[ room.zoneID ], unit )
				table.insert( cxt.units, unit )
			end
		else
			log:write( "ERR: couldn't place unit anywhere in room %s", tostring(room and room.roomIndex) )
		end
    end
end

local function generateThreats( cxt, spawnTable, spawnList )
    if not spawnList then
        spawnList = simdefs.SPAWN_TABLE[cxt.params.difficultyOptions.spawnTable][ cxt.params.difficulty ]
    end
	local spawnIndex = 1
	local roomsLeft = #cxt.rooms
    local zoneThreats = {} -- map of zoneID to threats.
	
    for spawnIndex = 1, #spawnList do
        local room, attempts = nil, 0
        local x, y = nil, nil
        while (x == nil or y == nil) and attempts < 20 do
            room = findThreatRoom( cxt, zoneThreats )
            if room then
                x, y = findGuardSpawn( cxt, zoneThreats[ room.zoneID ], room )
            end
            attempts = attempts + 1
        end
		if x and y then

            local spawns = util.weighted_list( spawnTable[ spawnList[ spawnIndex ]] )

            local templateName = spawns:getChoice( cxt.rnd:nextInt( 1, spawns:getTotalWeight() ))
			local unit =
			{
				x = x,
				y = y,
				template = templateName,
			}

            if isGuard( unit ) then
				unit = finalizeGuard( cxt, unit )
			end
            if unit then
                if zoneThreats[ room.zoneID ] == nil then
                    zoneThreats[ room.zoneID ] = {}
                end
                table.insert( zoneThreats[ room.zoneID ], unit )
				table.insert( cxt.units, unit )
			end
		else
			log:write( "ERR: couldn't place unit anywhere in room %s", tostring(room and room.roomIndex) )
		end
    end
end

local function generateGuardLoot( cxt, template )
	local unit = cxt:pickUnit( canCarryPasscards )
    if unit then
	    local templateUnitData = unitdefs.lookupTemplate( unit.template )
        if unit.unitData == nil then
            unit.unitData = {}
        end
	    unit.unitData.children = util.tdupe( templateUnitData.children )
	    table.insert( unit.unitData.children, template )
    end
end


 local function generateLaserGenerators( cxt, candidates )
    local laserCount = 0
    local allCandidates = util.tmerge( {}, candidates, cxt.candidates )
    for i, candidate in ipairs( allCandidates ) do
        if array.find( candidate.prefab.tags, "laser" ) then
            laserCount = laserCount + 1
        end
    end
    prefabs.generatePrefabs( cxt, candidates, "laser_generator", math.ceil( laserCount / 2 ) )
 end

 local function generateMainframes( cxt, candidates )
    if cxt.params.campaignDifficulty == simdefs.NORMAL_DIFFICULTY and cxt.params.missionCount == 0 then
        -- Suppress all mainframes in beginner on the first mission.
        return
    end

    -- This conditional should match the situation where daemons are spawned into the level.
     if cxt.difficulty > 1 then
	    prefabs.generatePrefabs( cxt, candidates, "mainframedb", cxt.rnd:nextInt( 0, 1 ) )
	    prefabs.generatePrefabs( cxt, candidates, "daemondb", 1 )
    else
	    prefabs.generatePrefabs( cxt, candidates, "mainframedb_nodaemon", cxt.rnd:nextInt( 0, 1 ) )
    end
end

 local function generateMiniServers( cxt, candidates )
    if cxt.params.campaignDifficulty == simdefs.NORMAL_DIFFICULTY and cxt.params.missionCount == 0 then
        -- No mini-servers on first mission beginner difficulty.
        return
    end

 	local toSpawn = false 

 	if cxt.rnd:nextInt( 0, 2 ) == 2 then 
 		toSpawn = true 
 	else 
 		toSpawn = false 
 	end 

	local miniserverRatio = cxt.params.miniserversSeen / cxt.params.missionCount 

	if miniserverRatio < 0.5 then 
		toSpawn = true 
	end 

	if toSpawn == true then 
		prefabs.generatePrefabs( cxt, candidates, "miniserver", 1 )
	end 
end

local function lootFitness( cxt, prefab, tx, ty )
	if prefab.rooms[1] then
		local x, y = prefab.rooms[1].rects[1].x0 + tx, prefab.rooms[1].rects[1].y0 + ty
		local room = cxt:roomContaining( x, y )
		if room then
			return math.pow( room.lootWeight, 2 )
		end
	end
	return 1
end


local function cameraFitness( candidates )
    return function( cxt, prefab, tx, ty )
        -- Fine the coordinates where the camera will spawn (tile coords + match offset + prefab rotation offset)
        local MIN_CAMERA_DISTANCE = 5
        local x0, y0 = prefab.camera.x + tx + prefab.tx, prefab.camera.y + ty + prefab.ty
        -- Count how many cameras 
        local room = cxt:roomContaining( x0, y0 )
        local count = 0
        for i, candidate in ipairs(candidates) do
            if candidate.prefab.filename == prefab.filename then
                local x1, y1 = candidate.prefab.camera.x + candidate.tx + candidate.prefab.tx, candidate.prefab.camera.y + candidate.ty + prefab.ty
                local r2 = cxt:roomContaining( x1, y1 )
                if r2.roomIndex == room.roomIndex then
                    if mathutil.dist2d( x0, y0, x1, y1 ) < MIN_CAMERA_DISTANCE then
                        return 0
                    end
                    count = count + 1
                end
            end
        end
        if count >= 2 then
            return 0
        else
            return 1
        end
    end
end

local function generateSideMission( params, cxt )
    local rand = rand.createGenerator( params.seed )

    if params.missionCount > 0 and isVersion(params, "0.17.9") and rand:nextInt(1,100) < 25 and #SIDEMISSIONS > 0 then --25
        params.side_mission = SIDEMISSIONS[rand:nextInt(1,#SIDEMISSIONS)]
    end

end

------------------------------------------------------------------------
-- FTM world gen.

local ftm = class( procgen_context )

function ftm:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_FTM_OFFICE, cdefs.ZONE_FTM_SECURITY, cdefs.ZONE_FTM_LAB }
	self.HALL_ZONE =  cdefs.ZONE_FTM_SECURITY_HALL
    self._cxt = procgen_context

    generateSideMission( self.params, self._cxt )
end


function ftm:generatePrefabs( )
	local candidates = {}
	
	self.NUM_CAMERAS = getCameraNumbers(self.params,self.difficulty)

    if isVersion(self.params, "0.17.9") then
        for i=1,simdefs.FTM_PREFABS_TABLE[self.difficulty] do
            prefabData = FTM.PREFABS[ self.rnd:nextInt(1,#FTM.PREFABS)  ]
            prefabs.generatePrefabs( self, candidates, prefabData.prefab, prefabData.num)        
        end          
    else        
        if self.difficulty >= 2 then
            prefabs.generatePrefabs( self, candidates, "scanner", 1)    
        end
    end

	if self.params.agency.blocker == true then 
		prefabs.generatePrefabs( self, candidates, "inhibitor", 2 )
	end 

	prefabs.generatePrefabs( self, candidates, "entry_guard", 2 )
	prefabs.generatePrefabs( self, candidates, "barrier", math.floor( self.NUM_BARRIERS/2 ) )
	prefabs.generatePrefabs( self, candidates, "console", self.NUM_CONSOLES )
	prefabs.generatePrefabs( self, candidates, "null_console", self.NUM_NULL_CONSOLES )
    generateMainframes( self, candidates )
    generateMiniServers( self, candidates )
	prefabs.generatePrefabs( self, candidates, "store", 1 )
	prefabs.generatePrefabs( self, candidates, "safe", self.NUM_SAFES, lootFitness )
	prefabs.generatePrefabs( self, candidates, "secret", 2 )
	prefabs.generatePrefabs( self, candidates, "camera", self.NUM_CAMERAS, cameraFitness( candidates ) )
	prefabs.generatePrefabs( self, candidates, "decor")

    generateLaserGenerators( self, candidates )

	return candidates
end

function ftm:generateUnit( unit )
    unit.template = unit.template:gsub( "security_laser_emitter_1x1", "security_infrared_emitter_1x1" )
    return unit
end

function ftm:generateUnits()
    local FTM_SPAWN_TABLE =
    {
        COMMON = FTM_GUARD,
        ELITE = FTM_THREAT,
        CAMERA_DRONE = CAMERA_DRONE,
        OMNI = OMNI_GUARD,
    }

    self._patrolGuard = FTM_GUARD

    -- this is to preserve savefiles on earlier versions due to the copying of the weighted list changing the order
    if not isVersion(self.params, "0.17.7") then
		FTM_SPAWN_TABLE =
		    {
		        COMMON = FTM_GUARD_DEFAULT,
		        ELITE = FTM_THREAT_DEFAULT,
		        CAMERA_DRONE = CAMERA_DRONE_DEFAULT,
		        OMNI = OMNI_GUARD_DEFAULT,
		    }

    	self._patrolGuard = FTM_GUARD_DEFAULT    	
    end

    -- adds LV2 guards to OMNI while maintaining old save games by not messing with the data.
    if isVersion( self.params, "0.17.9") then

        FTM_SPAWN_TABLE =
        {
            COMMON = FTM.GUARD_FIX,
            ELITE = FTM.THREAT_FIX,
            CAMERA_DRONE = CAMERA_DRONE_FIX,
            OMNI = FTM.LVL2,
        }

        self._patrolGuard = FTM.GUARD_FIX
    end

    generateThreats( self, FTM_SPAWN_TABLE )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )

	local LOCAL_DAEMONS = DAEMONS 

    if isVersion(self.params, "0.17.12") then
        LOCAL_DAEMONS = {}
        for i,program in ipairs(serverdefs.PROGRAM_LIST)do
            LOCAL_DAEMONS[program] = 1
        end
    end

   	self.ice_programs = util.weighted_list( LOCAL_DAEMONS )
end

------------------------------------------------------------------------
-- Plastech world gen.

local plastech = class( procgen_context )

function plastech:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_TECH_OFFICE, cdefs.ZONE_TECH_LAB, cdefs.ZONE_TECH_PSI }
	self.HALL_ZONE =  cdefs.ZONE_TECH_HALL

	self._cxt = procgen_context

    generateSideMission( self.params, self._cxt )
end

function plastech:generatePrefabs()
	local candidates = {}
	
	for i,prefabData in ipairs(PLASTECH.PREFABS) do 
		if self.difficulty >= prefabData.difficulty then
			prefabs.generatePrefabs( self, candidates, prefabData.prefab, prefabData.num)	
		end
	end

	self.NUM_CAMERAS = getCameraNumbers(self.params,self.difficulty)

	prefabs.generatePrefabs( self, candidates, "entry_guard", 2 )

	prefabs.generatePrefabs( self, candidates, "barrier", math.floor( self.NUM_BARRIERS/2 ) )
	prefabs.generatePrefabs( self, candidates, "console", self.NUM_CONSOLES )
	prefabs.generatePrefabs( self, candidates, "null_console", self.NUM_NULL_CONSOLES )
	generateMiniServers( self, candidates )
    generateMainframes( self, candidates )
	prefabs.generatePrefabs( self, candidates, "store", 1 )
	prefabs.generatePrefabs( self, candidates, "safe", self.NUM_SAFES, lootFitness )
	prefabs.generatePrefabs( self, candidates, "secret", 2 )
	prefabs.generatePrefabs( self, candidates, "camera", self.NUM_CAMERAS, cameraFitness( candidates ) )
	prefabs.generatePrefabs( self, candidates, "decor" )

    generateLaserGenerators( self, candidates )

	return candidates
end

function plastech:generateUnit( unit )
    unit.template = unit.template:gsub( "security_laser_emitter_1x1", "security_infrared_emitter_1x1" )
    return unit
end

function plastech:generateUnits()

    local PLASTECH_SPAWN_TABLE =
    {
        COMMON = PLASTECH_GUARD,
        ELITE = PLASTECH_THREAT,
        CAMERA_DRONE = CAMERA_DRONE,
        OMNI = OMNI_GUARD,
    }

	if isVersion( self.params, "0.17.5" ) then
		PLASTECH_SPAWN_TABLE.ELITE = PLASTECH_THREAT_0_17_5
	end

    self._patrolGuard = PLASTECH_GUARD

    -- this is to preserve savefiles on earlier versions due to the copying of the weighted list changing the order
    if not isVersion( self.params, "0.17.7") then
		PLASTECH_SPAWN_TABLE =
		    {
		        COMMON = PLASTECH_GUARD_DEFAULT,
		        ELITE = PLASTECH_THREAT_DEFAULT,
		        CAMERA_DRONE = CAMERA_DRONE_DEFAULT,
		        OMNI = OMNI_GUARD_DEFAULT,
		    }
			if isVersion( self.params, "0.17.5" ) then
				PLASTECH_SPAWN_TABLE.ELITE = PLASTECH_THREAT_0_17_5_DEFAULT
			end		    

    	self._patrolGuard = PLASTECH_GUARD_DEFAULT 	
    end

    -- adds LV2 guards to OMNI while maintaining old save games by not messing with the data.
    if isVersion( self.params, "0.17.9") then

        PLASTECH_SPAWN_TABLE =
        {
            COMMON = PLASTECH.GUARD_FIX,
            ELITE = PLASTECH.THREAT_FIX,
            CAMERA_DRONE = CAMERA_DRONE_FIX,
            OMNI = PLASTECH.LVL2,
        }

        self._patrolGuard = PLASTECH.GUARD_FIX
    end

    generateThreats( self, PLASTECH_SPAWN_TABLE )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	
    local LOCAL_DAEMONS = DAEMONS 

    if isVersion(self.params, "0.17.12") then
        LOCAL_DAEMONS = {}
        for i,program in ipairs(serverdefs.PROGRAM_LIST)do
            LOCAL_DAEMONS[program] = 1
        end
    end

    self.ice_programs = util.weighted_list( LOCAL_DAEMONS )
end

------------------------------------------------------------------------
-- K&O world gen.

local ko = class( procgen_context )

function ko:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_KO_OFFICE, cdefs.ZONE_KO_BARRACKS,cdefs.ZONE_KO_FACTORY }
	self.HALL_ZONE =  cdefs.ZONE_KO_HALL

    self._cxt = procgen_context
    generateSideMission( self.params, self._cxt )
end

function ko:generatePrefabs( )
	local candidates = {}

	self.NUM_CAMERAS = math.max(getCameraNumbers(self.params,self.difficulty) - self.difficulty,1)

	self.NUM_TURRETS = TURRET_NUMBERS[ self.difficulty ]

	prefabs.generatePrefabs( self, candidates, "entry_guard", 2 )

	for i,prefabData in ipairs(KO.PREFABS) do 
		if self.difficulty >= prefabData.difficulty then
			prefabs.generatePrefabs( self, candidates, prefabData.prefab, prefabData.num)	
		end
	end


	if self.params.agency.blocker == true then 
		prefabs.generatePrefabs( self, candidates, "inhibitor", 2 )
	end 

	prefabs.generatePrefabs( self, candidates, "turret", self.NUM_TURRETS )

	prefabs.generatePrefabs( self, candidates, "barrier", math.floor( self.NUM_BARRIERS/2 ) )
	prefabs.generatePrefabs( self, candidates, "console", self.NUM_CONSOLES )
	prefabs.generatePrefabs( self, candidates, "null_console", self.NUM_NULL_CONSOLES )
	generateMiniServers( self, candidates )
    generateMainframes( self, candidates )
	prefabs.generatePrefabs( self, candidates, "store", 1 )
	prefabs.generatePrefabs( self, candidates, "safe", self.NUM_SAFES, lootFitness )
	prefabs.generatePrefabs( self, candidates, "secret", 2 )
	prefabs.generatePrefabs( self, candidates, "camera", self.NUM_CAMERAS, cameraFitness( candidates ) )
	prefabs.generatePrefabs( self, candidates, "decor" )

    generateLaserGenerators( self, candidates )

	return candidates
end

function ko:generateUnits()
    local KO_SPAWN_TABLE =
    {
        COMMON = KO_GUARD,
        ELITE = KO_THREAT,
        CAMERA_DRONE = CAMERA_DRONE,
        OMNI = OMNI_GUARD,
    }
    self._patrolGuard = KO_GUARD

    -- this is to preserve savefiles on earlier versions due to the copying of the weighted list changing the order
    if not isVersion( self.params, "0.17.7") then
		    KO_SPAWN_TABLE =
		    {
		        COMMON = KO_GUARD_DEFAULT,
		        ELITE = KO_THREAT_DEFAULT,
		        CAMERA_DRONE = CAMERA_DRONE_DEFAULT,
		        OMNI = OMNI_GUARD_DEFAULT,
		    }    

    	self._patrolGuard = KO_GUARD_DEFAULT 	
    end

    -- adds LV2 guards to OMNI while maintaining old save games by not messing with the data.
    if isVersion( self.params, "0.17.9") then

        KO_SPAWN_TABLE =
        {
            COMMON = KO.GUARD_FIX,
            ELITE = KO.THREAT_FIX,
            CAMERA_DRONE = CAMERA_DRONE_FIX,
            OMNI = KO.LVL2,
        }
        self._patrolGuard = KO.GUARD_FIX
    end


    generateThreats( self, KO_SPAWN_TABLE )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )

    local LOCAL_DAEMONS = DAEMONS 

    if isVersion(self.params, "0.17.12") then
        LOCAL_DAEMONS = {}
        for i,program in ipairs(serverdefs.PROGRAM_LIST)do
            LOCAL_DAEMONS[program] = 1
        end
    end

    self.ice_programs = util.weighted_list( LOCAL_DAEMONS )
end

------------------------------------------------------------------------
-- Sankaku world gen.

local sankaku = class( procgen_context )

function sankaku:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_SK_OFFICE, cdefs.ZONE_SK_LAB, cdefs.ZONE_SK_BAY }
	self.HALL_ZONE =  cdefs.ZONE_SK_LAB

    self._cxt = procgen_context
    generateSideMission( self.params, self._cxt )
end

function sankaku:generatePrefabs(  )
	local candidates = {}

	for i,prefabData in ipairs(SANKAKU.PREFABS) do 
		if self.difficulty >= prefabData.difficulty then
			prefabs.generatePrefabs( self, candidates, prefabData.prefab, prefabData.num)	
		end
	end

	if self.params.agency.blocker == true then 
		prefabs.generatePrefabs( self, candidates, "inhibitor", 2 )
	end 

	self.NUM_CAMERAS = getCameraNumbers(self.params,self.difficulty)

	prefabs.generatePrefabs( self, candidates, "entry_guard", 2 )

	prefabs.generatePrefabs( self, candidates, "barrier", math.floor( self.NUM_BARRIERS/2 ) )
	prefabs.generatePrefabs( self, candidates, "console", 6 )

    if self.difficulty >= 2 then
		prefabs.generatePrefabs( self, candidates, "soundbug", 6 )
	end	
    generateMainframes( self, candidates )
    generateMiniServers( self, candidates )

	prefabs.generatePrefabs( self, candidates, "store", 1)
	prefabs.generatePrefabs( self, candidates, "safe", self.NUM_SAFES )
	prefabs.generatePrefabs( self, candidates, "secret", 2 )
	prefabs.generatePrefabs( self, candidates, "camera", self.NUM_CAMERAS, cameraFitness( candidates ) )
	prefabs.generatePrefabs( self, candidates, "decor" )

    generateLaserGenerators( self, candidates )
	return candidates
end

function sankaku:generateUnit( unit )
    unit.template = unit.template:gsub( "security_laser_emitter_1x1", "security_infrared_wall_emitter_1x1" )
    return unit
end

function sankaku:generateUnits()
    local SANKAKU_SPAWN_TABLE =
    {
        COMMON = SANKAKU_GUARD,
        COMMON_HUMAN = SANKAKU_HUMAN_GUARD,
        ELITE = SANKAKU_THREAT,
        ELITE_HUMAN = SANKAKU_HUMAN_THREAT,
        CAMERA_DRONE = CAMERA_DRONE,
        OMNI = OMNI_GUARD,
    }
    self._patrolGuard = SANKAKU_GUARD

    -- this is to preserve savefiles on earlier versions due to the copying of the weighted list changing the order
    if not isVersion( self.params, "0.17.7") then
        SANKAKU_SPAWN_TABLE =
        {
                COMMON = SANKAKU_GUARD_DEFAULT,
                COMMON_HUMAN = SANKAKU_HUMAN_GUARD_DEFAULT,
                ELITE = SANKAKU_THREAT_DEFAULT,
                ELITE_HUMAN = SANKAKU_HUMAN_THREAT_DEFAULT,
                CAMERA_DRONE = CAMERA_DRONE_DEFAULT,
                OMNI = OMNI_GUARD_DEFAULT,
        }   

        self._patrolGuard = SANKAKU_GUARD_DEFAULT    
    end


    -- adds LV2 guards to OMNI while maintaining old save games by not messing with the data.
    if isVersion( self.params, "0.17.9") then

        SANKAKU_SPAWN_TABLE =
        {
            COMMON = SANKAKU.GUARD_DEFAULT_FIX,
            COMMON_HUMAN = SANKAKU.HUMAN_GUARD_DEFAULT_FIX,
            ELITE = SANKAKU.THREAT_DEFAULT_FIX,
            ELITE_HUMAN = SANKAKU.HUMAN_THREAT_DEFAULT_FIX,
            CAMERA_DRONE = CAMERA_DRONE_DEFAULT_FIX,
            OMNI = SANKAKU.LVL2,
        }
        self._patrolGuard = SANKAKU.GUARD_DEFAULT_FIX
    end

    if isVersion( self.params, "0.17.15") then
        SANKAKU_SPAWN_TABLE =
        {
            COMMON = SANKAKU.GUARD_DEFAULT_FIX,
            COMMON_HUMAN = SANKAKU.HUMAN_GUARD_DEFAULT_FIX,
            ELITE = SANKAKU.THREAT_DEFAULT_FIX,
            ELITE_HUMAN = SANKAKU.HUMAN_THREAT_DEFAULT_FIX,
            CAMERA_DRONE = CAMERA_DRONE_DEFAULT_FIX,
            OMNI = SANKAKU.LVL2,
            OMNI_HUMAN = OMNI_GUARD,
        }
        self._patrolGuard = SANKAKU.GUARD_DEFAULT_FIX
    end


    -- Ensure there's at least one human in the level.  Cause ya know, AI could be taking over...
    local spawnList = util.tcopy( simdefs.SPAWN_TABLE[ self.params.difficultyOptions.spawnTable ][ self.params.difficulty ] )
    if array.find( spawnList, "COMMON" ) then
        array.removeElement( spawnList, "COMMON" )
        table.insert( spawnList, "COMMON_HUMAN" )
    elseif array.find( spawnList, "ELITE" ) then
        array.removeElement( spawnList, "ELITE" )
        table.insert( spawnList, "ELITE_HUMAN" )
    elseif array.find( spawnList, "OMNI" ) and SANKAKU_SPAWN_TABLE.OMNI_HUMAN then
        array.removeElement( spawnList, "OMNI" )
        table.insert( spawnList, "OMNI_HUMAN" )
    end

    generateThreats( self, SANKAKU_SPAWN_TABLE, spawnList )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )

    local LOCAL_DAEMONS = DAEMONS 

    if isVersion(self.params, "0.17.12") then
        LOCAL_DAEMONS = {}
        for i,program in ipairs(serverdefs.PROGRAM_LIST)do
            LOCAL_DAEMONS[program] = 1
        end
    end

    self.ice_programs = util.weighted_list( LOCAL_DAEMONS )
end

------------------------------------------------------------------------
-- Omni world gen.

local omni = class( procgen_context )

function omni:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_OM_HOLO,cdefs.ZONE_OM_MISSION }	
	self.HALL_ZONE =  cdefs.ZONE_OM_HALL

end

function omni:generatePrefabs(  )
	local candidates = {}

	for i,prefabData in ipairs(OMNI.PREFABS) do 
		if self.difficulty >= prefabData.difficulty then
			prefabs.generatePrefabs( self, candidates, prefabData.prefab, prefabData.num)	
		end
	end

	self.NUM_CAMERAS = getCameraNumbers(self.params,self.difficulty)

	prefabs.generatePrefabs( self, candidates, "entry_guard", 2 )

	prefabs.generatePrefabs( self, candidates, "barrier", math.floor( self.NUM_BARRIERS/2 ) )
	prefabs.generatePrefabs( self, candidates, "console", 6 )

	prefabs.generatePrefabs( self, candidates, "store", 1)

    generateMainframes( self, candidates )

	prefabs.generatePrefabs( self, candidates, "camera", self.NUM_CAMERAS, cameraFitness( candidates ) )
	prefabs.generatePrefabs( self, candidates, "decor" )

    generateLaserGenerators( self, candidates )

	return candidates
end

function omni:generateUnit( unit )
    unit.template = unit.template:gsub( "security_laser_emitter_1x1", "security_infrared_wall_emitter_1x1" )
    return unit
end

function omni:generateUnits()

    local OMNI_SPAWN_TABLE =
    {
        PROTECTOR = { omni_protector = 100 },
        SOLDIER = { omni_soldier = 100 },
        CRIER = { omni_crier = 100 },
        OMNI = OMNI_GUARD,
        OMNI_NON_SOLDIER = { omni_crier = 50, omni_protector = 50 },
        CAMERA_DRONE = CAMERA_DRONE,
    }

    self._patrolGuard = OMNI_GUARD

    -- adds LV2 guards to OMNI while maintaining old save games by not messing with the data.
    if isVersion( self.params, "0.17.9") then

        local OMNI_SPAWN_TABLE =
        {
            PROTECTOR = { {"omni_protector",100} },
            SOLDIER = { {"omni_soldier",100} },
            CRIER = { {"omni_crier",100} },
            OMNI = OMNI_GUARD_FIX,
            OMNI_NON_SOLDIER = { {"omni_crier",50}, {"omni_protector",50} },
            CAMERA_DRONE = CAMERA_DRONE_FIX,
        }

        self._patrolGuard = OMNI_GUARD_FIX
    end

    local spawnList = simdefs.OMNI_SPAWN_TABLE[ self.params.difficultyOptions.spawnTable ]
    generateThreats( self, OMNI_SPAWN_TABLE, spawnList )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )
	generateGuardLoot( self, unitdefs.prop_templates.passcard )


    local LOCAL_DAEMONS = OMNI_DAEMONS 

    if isVersion(self.params, "0.17.12") then
        LOCAL_DAEMONS = {}
        for i,program in ipairs(serverdefs.OMNI_PROGRAM_LIST)do
            LOCAL_DAEMONS[program] = 1
        end
    end

    self.ice_programs = util.weighted_list( LOCAL_DAEMONS )
end

------------------------------------------------------------------------
-- Trial worldgen, for testing.

local trial = class( procgen_context )

function trial:init( ... )
	procgen_context.init( self, ... )

	self.ZONES = { cdefs.ZONE_FTM_OFFICE, cdefs.ZONE_FTM_SECURITY }
	self.HALL_ZONE =  cdefs.ZONE_FTM_SECURITY_HALL
end

function trial:generatePrefabs(  )
	return {}
end

function trial:generateUnits()
end

------------------------------------------------------------------------


local worlds = {
	ftm = ftm,
	plastech = plastech,
	ko = ko,
	sankaku = sankaku,
	omni = omni,
	trial = trial,
}

addWorldPrefabs("ftm")
addWorldPrefabs("plastech")
addWorldPrefabs("ko")
addWorldPrefabs("sankaku")
addWorldPrefabs("omni")


local function createContext( params, pass )

	if worlds[params.world] then
		return worlds[params.world]( params, pass )
	else	
		assert( false, "Unknown world: " .. params.world )		
	end
end

function ResetGuardsWorldGen()
   	log:write("ResetGuardsWorldGen()")

    --old vars
	util.tclear(CAMERA_DRONE)
	util.tmerge(CAMERA_DRONE, CAMERA_DRONE_DEFAULT)

	util.tclear(FTM_THREAT)
	util.tmerge(FTM_THREAT, FTM_THREAT_DEFAULT)
	util.tclear(FTM_GUARD)
	util.tmerge(FTM_GUARD, FTM_GUARD_DEFAULT)

	util.tclear(PLASTECH_THREAT)
	util.tmerge(PLASTECH_THREAT, PLASTECH_THREAT_DEFAULT)
	util.tclear(PLASTECH_THREAT_0_17_5)
	util.tmerge(PLASTECH_THREAT_0_17_5, PLASTECH_THREAT_0_17_5_DEFAULT)
	util.tclear(PLASTECH_GUARD)
	util.tmerge(PLASTECH_GUARD, PLASTECH_GUARD_DEFAULT)

	util.tclear(KO_THREAT)
	util.tmerge(KO_THREAT, KO_THREAT_DEFAULT)
	util.tclear(KO_GUARD)
	util.tmerge(KO_GUARD, KO_GUARD_DEFAULT)

	util.tclear(SANKAKU_THREAT)
	util.tmerge(SANKAKU_THREAT, SANKAKU_THREAT_DEFAULT)
	util.tclear(SANKAKU_HUMAN_THREAT)
	util.tmerge(SANKAKU_HUMAN_THREAT, SANKAKU_HUMAN_THREAT_DEFAULT)
	util.tclear(SANKAKU_GUARD)
	util.tmerge(SANKAKU_GUARD, SANKAKU_GUARD_DEFAULT)
	util.tclear(SANKAKU_HUMAN_GUARD)
	util.tmerge(SANKAKU_HUMAN_GUARD, SANKAKU_HUMAN_GUARD_DEFAULT)

	util.tclear(OMNI_GUARD)
	util.tmerge(OMNI_GUARD, OMNI_GUARD_DEFAULT)

    -- new ordered vars
    util.tclear(CAMERA_DRONE_FIX)
    util.tmerge(CAMERA_DRONE_FIX, CAMERA_DRONE_DEFAULT_FIX)

    util.tclear(FTM.THREAT_FIX)
    util.tmerge(FTM.THREAT_FIX, FTM.THREAT_DEFAULT_FIX)
    util.tclear(FTM.GUARD_FIX)
    util.tmerge(FTM.GUARD_FIX, FTM.GUARD_DEFAULT_FIX)

    util.tclear(PLASTECH.THREAT_FIX)
    util.tmerge(PLASTECH.THREAT_FIX, PLASTECH.THREAT_DEFAULT_FIX)
    util.tclear(PLASTECH.GUARD_FIX)
    util.tmerge(PLASTECH.GUARD_FIX, PLASTECH.GUARD_DEFAULT_FIX)

    util.tclear(KO.THREAT_FIX)
    util.tmerge(KO.THREAT_FIX, KO.THREAT_DEFAULT_FIX)
    util.tclear(KO.GUARD_FIX)
    util.tmerge(KO.GUARD_FIX, KO.GUARD_DEFAULT_FIX)

    util.tclear(SANKAKU.THREAT_FIX)
    util.tmerge(SANKAKU.THREAT_FIX, SANKAKU.THREAT_DEFAULT_FIX)
    util.tclear(SANKAKU.HUMAN_THREAT_FIX)
    util.tmerge(SANKAKU.HUMAN_THREAT_FIX, SANKAKU.HUMAN_THREAT_DEFAULT_FIX)
    util.tclear(SANKAKU.GUARD_FIX)
    util.tmerge(SANKAKU.GUARD_FIX, SANKAKU.GUARD_DEFAULT_FIX)
    util.tclear(SANKAKU.HUMAN_GUARD_FIX)
    util.tmerge(SANKAKU.HUMAN_GUARD_FIX, SANKAKU.HUMAN_GUARD_DEFAULT_FIX)

    util.tclear(OMNI_GUARD_FIX)
    util.tmerge(OMNI_GUARD_FIX, OMNI_GUARD_DEFAULT_FIX)

    util.tclear(FTM.LVL2)
    util.tmerge(FTM.LVL2, FTM.LVL2_DEFAULT, OMNI_GUARD_FIX)
    util.tclear(SANKAKU.LVL2)
    util.tmerge(SANKAKU.LVL2, SANKAKU.LVL2_DEFAULT, OMNI_GUARD_FIX)
    util.tclear(KO.LVL2)
    util.tmerge(KO.LVL2, KO.LVL2_DEFAULT, OMNI_GUARD_FIX)
    util.tclear(PLASTECH.LVL2)
    util.tmerge(PLASTECH.LVL2, PLASTECH.LVL2_DEFAULT, OMNI_GUARD_FIX)

    util.tclear(FTM.PREFABS)
    util.tmerge(FTM.PREFABS, FTM.PREFABS_DEFAULT)
    util.tclear(KO.PREFABS)
    util.tmerge(KO.PREFABS, KO.PREFABS_DEFAULT)
    util.tclear(SANKAKU.PREFABS)
    util.tmerge(SANKAKU.PREFABS, SANKAKU.PREFABS_DEFAULT)
    util.tclear(PLASTECH.PREFABS)
    util.tmerge(PLASTECH.PREFABS, PLASTECH.PREFABS_DEFAULT)   

    util.tclear(SIDEMISSIONS)
    util.tmerge(SIDEMISSIONS, SIDEMISSIONS_DEFAULT) 
    
end

ResetGuardsWorldGen()

return
{
	CAMERA_DRONE = CAMERA_DRONE,
	FTM_THREAT = FTM_THREAT,
	FTM_GUARD = FTM_GUARD,
	PLASTECH_THREAT = PLASTECH_THREAT,
	PLASTECH_THREAT_0_17_5 = PLASTECH_THREAT_0_17_5,
	PLASTECH_GUARD = PLASTECH_GUARD,
	KO_THREAT = KO_THREAT,
	KO_GUARD = KO_GUARD,
	SANKAKU_THREAT = SANKAKU_THREAT,
	SANKAKU_HUMAN_THREAT = SANKAKU_HUMAN_THREAT,
	SANKAKU_GUARD = SANKAKU_GUARD,
	SANKAKU_HUMAN_GUARD = SANKAKU_HUMAN_GUARD,
	OMNI_GUARD = OMNI_GUARD,

    SIDEMISSIONS = SIDEMISSIONS,

    FTM = FTM,
    SANKAKU = SANKAKU,
    PLASTECH = PLASTECH,
    KO = KO,

    OMNI_GUARD_FIX = OMNI_GUARD_FIX,
    CAMERA_DRONE_FIX = CAMERA_DRONE_FIX,
    
	createContext = createContext,

	canGuardSpawn = canGuardSpawn,
	canSpawnThreat = canSpawnThreat,
	findThreatRoom = findThreatRoom,
	findGuardSpawn = findGuardSpawn,
	isGuard = isGuard,
	canCarryPasscards = canCarryPasscards,
	hasTag = hasTag,
	getCameraNumbers = getCameraNumbers,
	finalizeGuard = finalizeGuard,
	generateThreats = generateThreats,     
	generateGuardLoot = generateGuardLoot,

	OMNI_DAEMONS = OMNI_DAEMONS,
	DAEMONS = DAEMONS,

	generateLaserGenerators = generateLaserGenerators,
	generateMainframes = generateMainframes,
	generateMiniServers = generateMiniServers,
	lootFitness = lootFitness,
	cameraFitness = cameraFitness,
	isVersion = isVersion,
	worlds = worlds,
	spawnUnits = spawnUnits,

}



















