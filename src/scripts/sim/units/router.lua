----------------------------------------------------------------
-- Copyright (c) 2012 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local util = include( "modules/util" )
local array = include( "modules/array" )
local simunit = include( "sim/simunit" )
local simquery = include( "sim/simquery" )
local simdefs = include( "sim/simdefs" )
local simfactory = include( "sim/simfactory" )
local inventory = include( "sim/inventory" )
local abilitydefs = include( "sim/abilitydefs" )
local cdefs = include( "client_defs" )

-----------------------------------------------------
-- Local functions

local router = { ClassType = "router" }

function router:onWarp( sim, oldcell, cell )
	if oldcell then
		self:deactivate( sim )
	end

	if cell and self:getTraits().startOn == true then
		self:activate( sim )
	end
end


function router:activate( sim )
	if  self:getTraits().mainframe_status == "inactive" then
		self:getTraits().mainframe_status = "active"

		if self:getSounds().spot_old then
			self:getSounds().spot = self:getSounds().spot_old		
			self:getSounds().spot_old = nil
		end

        sim:addTrigger( simdefs.TRG_START_TURN, self )

		sim:dispatchEvent( simdefs.EV_PLAY_SOUND, "SpySociety/Actions/mainframe_object_on" )
	end
end

function router:deactivate( sim )	
	sim:triggerEvent( simdefs.TRG_UNIT_DISABLED, self )

	if self:getTraits().mainframe_status == "active" then
		self:getTraits().mainframe_status = "inactive"

		self:getSounds().spot_old = self:getSounds().spot		
		self:getSounds().spot = nil			

        sim:removeTrigger( simdefs.TRG_START_TURN, self )
        self:destroyTab()
		sim:dispatchEvent( simdefs.EV_PLAY_SOUND, "SpySociety/Actions/mainframe_object_off" )
	end
end

function router:onTrigger( sim, evType, evData )
	if evType == simdefs.TRG_START_TURN then
		if evData:isNPC() then
			local pool = {}
			for i, unit in pairs(sim:getAllUnits())do

				if unit:getTraits().mainframe_ice and unit:getTraits().mainframe_ice >0 and not unit:isPC() and unit:getTraits().mainframe_status and unit:getTraits().mainframe_status == "active" then
					if unit ~= self then
						table.insert(pool,unit)
					end
				end
			end

			if #pool > 0 then			
				local target = pool[math.floor(sim:nextRand()*#pool)+1]
				target:increaseIce(sim,1)
				sim:dispatchEvent( simdefs.EV_SHOW_WARNING, {txt=STRINGS.UI.ROUTER_ALERT, color=cdefs.COLOR_CORP_WARNING, sound = "SpySociety_DLC001/HUD/gameplay/DLCrouter_firewall_increase",icon=nil} )
				sim:dispatchEvent( simdefs.EV_UNIT_ADD_FX, { unit = target, kanim = "gui/hud_fx", symbol = "wireless_console_takeover", anim="idle", above=true, params={} } )
				sim:dispatchEvent( simdefs.EV_UNIT_ADD_FX, { unit = self, kanim = "gui/hud_fx", symbol = "wireless_console_takeover", anim="idle", above=true, params={} } )
				sim:dispatchEvent( simdefs.EV_WAIT_DELAY, 60 )
			end		
		end

    end
end

function router:removeChild( childUnit )
    simunit.removeChild( self, childUnit )
    if childUnit:getTraits().artifact then
        self:processEMP( nil )
        self:getSim():triggerEvent( simdefs.TRG_UNIT_DISABLED, self )
    end
end

-----------------------------------------------------
-- Interface functions

local function createRouter( unitData, sim )
	return simunit.createUnit( unitData, sim, router )
end

simfactory.register( createRouter )

return
{
	createRouter = createRouter,
}

