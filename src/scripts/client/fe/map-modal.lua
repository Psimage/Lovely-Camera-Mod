local util = include( "client_util" )
local cdefs = include( "client_defs" )
local mathutil = include( "modules/mathutil" )
local rig_util = include( "gameplay/rig_util" )
local mui_defs = include( "mui/mui_defs" )
local mui = include( "mui/mui" )
local simfactory = include( "sim/simfactory" )
local itemdefs = include("sim/unitdefs/itemdefs")

local map_modal = class()

local SET_COLOR = {r=244/255,g=255/255,b=120/255, a=1}

function map_modal:init( data  )
    local screen = mui.createScreen( "modal-map-popup.lua" )
	mui.activateScreen( screen )			

    self.isdone = false

	MOAIFmodDesigner.playSound( "SpySociety/HUD/gameplay/unlock_agent" )

    self.screen = screen
    self.ok_button = screen:findWidget("okBtn.btn")

    self.ok_button.onClick = function() self:Hide() end 
    self.ok_button:setText(STRINGS.UI.CONTINUE)

    local widget = screen:findWidget("titleTxt2")

    widget:setText(data.title)

    for i=1,3 do
        local widget = screen:findWidget("Group"..i)
        widget:setVisible(false)
    end

    for i,group in ipairs(data.groups)do
        local widget = screen:findWidget("Group"..i)
        widget:setVisible(true)
        widget.binder.title:setText(group.title)
        widget:findWidget("text"):setText(group.text)
        widget:findWidget("img"):setImage(group.img)
    end
    
    inputmgr.addListener( self, 1 )
end

function map_modal:IsDone()
    return self.isdone
end

function map_modal:onInputEvent( event )
    if event.eventType == mui_defs.EVENT_KeyDown then
        if event.key == mui_defs.K_ENTER then
            self:Hide()
            return true

        elseif util.isKeyBindingEvent( "pause", event ) then
            self:Hide()
            return true
        end
    end
end

function map_modal:Hide(  )
    inputmgr.removeListener( self )

    mui.deactivateScreen( self.screen ) 
    MOAIFmodDesigner.playSound( cdefs.SOUND_HUD_GAME_WOOSHOUT ) 
    self.isdone = true
end

return map_modal
