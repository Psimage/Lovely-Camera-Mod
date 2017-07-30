-- COMOD: Lovely camera
-- Based on simcamera unit (simcamera.lua)

----------------------------------------------------------------
-- Copyright (c) 2012 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local util = include( "modules/util" )
local array = include( "modules/array" )
local simunit = include( "sim/simunit" )
local simdefs = include( "sim/simdefs" )
local simquery = include( "sim/simquery" )
local simfactory = include( "sim/simfactory" )
local cdefs = include( "client_defs" )

-----------------------------------------------------
-- Local functions

local comod_lovely_simcamera =
{
	ClassType = "comod_lovely_simcamera",
}

function comod_lovely_simcamera:activate( sim )
	if  self:getTraits().mainframe_status == "inactive" then
		self:getTraits().mainframe_status = "active"
		self:getTraits().hasSight = true
		sim:refreshUnitLOS( self )
		sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = self } )

	for i, targetUnit in ipairs( self:getSeenUnits() ) do
		if self:canTrackTarget( targetUnit ) then
			self:performTracking( sim, targetUnit )
			break
		end
	end

	end
end

function comod_lovely_simcamera:deactivate( sim )
	if self:getTraits().mainframe_status == "active" then
		self:getTraits().mainframe_status = "inactive"
		self:getTraits().hasSight = nil
		sim:refreshUnitLOS( self )
		sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = self } )
	end
end


function comod_lovely_simcamera:performTracking( sim, seenUnit )
	local x0, y0 = self:getLocation()
	local x1, y1 = seenUnit:getLocation()

	if self:getTraits().tracker_alert then
		sim:triggerEvent( simdefs.TRG_NEW_INTEREST, { x = x0, y = y0, range = simdefs.SOUND_RANGE_3, interest = { x= x1, y = y1, reason=simdefs.REASON_CAMERA} })
		if seenUnit and seenUnit:getPlayerOwner() then
			seenUnit:getPlayerOwner():glimpseUnit( sim, self:getID() )
		end
	else
		self:getTraits().tracker_alert = true

		sim:triggerEvent( simdefs.TRG_NEW_INTEREST, { x = x0, y = y0, range = simdefs.SOUND_RANGE_3, interest = { x= x1, y = y1, reason=simdefs.REASON_CAMERA} })
		sim:dispatchEvent( simdefs.EV_UNIT_ALERTED, { unitID = self:getID() } )

		sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=util.sformat(  STRINGS.UI.ALARM_ADD, 1 ),x=x0,y=y0,color={r=255/255,g=10/255,b=10/255,a=1}} )
		sim:trackerAdvance( 1, STRINGS.UI.ALARM_CAMERA_SCAN )
		sim:triggerEvent( simdefs.TRG_CAUGHT_BY_CAMERA)

		if seenUnit then
			if seenUnit:getPlayerOwner() then
				seenUnit:getPlayerOwner():glimpseUnit( sim, self:getID() )
			end
			sim:dispatchEvent( simdefs.EV_CAM_PAN, { seenUnit:getLocation() } )
			sim:dispatchEvent( simdefs.EV_UNIT_RESET_ANIM_PLAYBACK, { unit = seenUnit } )
		end
	end
end

function comod_lovely_simcamera:onDamage( damage, sim)
	self:getTraits().dead = true
	self:deactivate( self._sim )
	self:getTraits().mainframe_status = "off" -- Broken.
	self:getTraits().mainframe_booting = nil

	local x1,y1 = self:getLocation()
	sim:emitSound( simdefs.SOUND_CAMERA_DESTROYED, x1, y1, self )
	sim:dispatchEvent( simdefs.EV_UNIT_DEATH, { unit = self } )
end

function comod_lovely_simcamera:onWarp( sim, oldcell, cell)
	if not oldcell and cell then
		-- On Spawn/On Add (on map)
		sim:addTrigger( simdefs.TRG_START_TURN, self )
	elseif oldcell and not cell then
		-- On Remove (from map)
		sim:removeTrigger( simdefs.TRG_START_TURN, self )
		sim:removeTrigger( simdefs.TRG_OVERWATCH, self )
	elseif oldcell and cell then
		-- On Teleport (from oldcell to cell)
	end
end

function comod_lovely_simcamera:onEndTurn( sim )
	simunit.onEndTurn( self, sim )
	sim:removeTrigger( simdefs.TRG_OVERWATCH, self )

	if sim:getCurrentPlayer():isPC() then
		self:getTraits().tracker_alert = false
		if self:getTraits().mainframe_status == "active" and self:getTraits().hasSight == true then
			if self._facing == self._facingLeft then
				self._facing = self._facingRight
			else
				self._facing = self._facingLeft
			end

			sim:refreshUnitLOS( self )
			sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = self } )

			for i, targetUnit in ipairs( self:getSeenUnits() ) do
				if self:canTrackTarget( targetUnit ) then
					self:performTracking( sim, targetUnit )
					break
				end
			end
		end
	end
end

function comod_lovely_simcamera:canTrackTarget( targetUnit )
	if not self:isPC() then
		if targetUnit and simquery.isEnemyAgent( self:getPlayerOwner(), targetUnit ) and not targetUnit:isKO() then
			if self._sim:canUnitSeeUnit( self, targetUnit ) then
				return true
			end
		end
	end
	return false
end

function comod_lovely_simcamera:onTrigger( sim, evType, evData )
	if self:getTraits().mainframe_status ~= "active" or self:isPC() then
		return
	end

	if evType == simdefs.TRG_START_TURN then
		if evData ~= nil and evData:isPC() then
			sim:addTrigger( simdefs.TRG_OVERWATCH, self )
			sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = self } )
		end
	elseif evType == simdefs.TRG_OVERWATCH then
		if self:canTrackTarget( evData ) then
			if not self:getTraits().tracker_alert then
				evData:interruptMove( sim, self )
			end
			self:performTracking( sim, evData )
		end
	end
end

function simunit:getFacingRad( )
	if self._facing == self._facingLeft then
		return (math.pi / 4 * (self._facing) ) -- - math.pi/8 + math.pi/24)
	else
		return (math.pi / 4 * (self._facing) ) -- + math.pi/8 - math.pi/24)
	end
end
-----------------------------------------------------
-- Interface functions

local function createCamera( unitData, sim )
	local camera = simunit.createUnit( unitData, sim, comod_lovely_simcamera )

	camera._facingLeft = (camera._facing + 1) % simdefs.DIR_MAX
	camera._facingRight = (camera._facing - 1) % simdefs.DIR_MAX

	-- Class factory creates a test object to do some checks (calls it without any arguments)
	if sim then
		camera._facing = sim:nextRand(2) == 2 and camera._facingLeft or camera._facingRight
	end

	return camera
end

simfactory.register( createCamera )

return comod_lovely_simcamera
