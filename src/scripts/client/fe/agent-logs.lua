----------------------------------------------------------------
-- Copyright (c) 2012 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local game = include( "modules/game" )
local util = include("client_util")
local array = include( "modules/array" )
local mui = include( "mui/mui" )
local mui_defs = include( "mui/mui_defs" ) 
local serverdefs = include( "modules/serverdefs" )
local agentdefs = include("sim/unitdefs/agentdefs")
local skilldefs = include( "sim/skilldefs" )
local modalDialog = include( "states/state-modal-dialog" )
local scroll_text = include("hud/scroll_text")
local unitdefs = include("sim/unitdefs")
local simfactory = include( "sim/simfactory" )
local guiex = include( "client/guiex" )
local cdefs = include( "client_defs" )
local rig_util = include( "gameplay/rig_util" )
local SCRIPTS = include('client/story_scripts')
local talkinghead = include('client/fe/talkinghead')


local function onClickCloseLog(self)
	local profile = self.screen.binder.profile 
	profile.binder.profileImg:setVisible(false)
	profile.binder.profileAnim:setVisible(false)	

	MOAIFmodDesigner.playSound( "SpySociety/HUD/menu/popdown" )
    self:destroy()
end

local function onClickBioPrev(self, nextBtn, prevBtn, textWidget, text )

	textWidget:setText(text)
	nextBtn:setVisible(true)
	
	textWidget._pageNumber = textWidget._pageNumber -1
	
	for i= textWidget._pageNumber,0, -1 do
		textWidget:nextPage()
		textWidget._cont._prop:forceUpdate()
	end

	if textWidget._pageNumber == 0 then
		prevBtn:setVisible(false)
	else
		prevBtn:setVisible(true)
	end
end


local function onClickBioNext(self, nextBtn, prevBtn, textWidget )
	textWidget:nextPage()
	if textWidget:hasNextPage() then
		nextBtn:setVisible(true)
	else 
		nextBtn:setVisible(false)
	end

	textWidget._pageNumber = textWidget._pageNumber +1

	prevBtn:setVisible(true)
end

local function onDeleteLog(self, logIndex)
	local modalDialog = include( "states/state-modal-dialog" )
	local result = modalDialog.showYesNo( STRINGS.UI.DELETE_LOG_AREYOUSURE, STRINGS.UI.DELETE_LOG, nil, STRINGS.UI.DELETE_LOG, nil, true )
	if result == modalDialog.OK then

	    local user = savefiles.getCurrentGame()				   
	   
	    if user.data.logs then	    
	    	table.remove(user.data.logs,logIndex)	    
	    	user:save()
	    end
		self:refresh()	
	end
end

local function onLogClicked(self, log, logIndex )

	local blurb = log.body
	local title = log.title
	local profileImg = log.profileImg
	local profileAnim = log.profileAnim
	local profileBuild = log.profileBuild
	local footerName = log.footerName
	local footerIcon = log.footerIcon
	local footerAuthor = log.footerAuthor	

	self.screen:findWidget("deleteBtn"):setVisible(true)
	self.screen:findWidget("deleteBtn").onClick = util.makeDelegate( nil, onDeleteLog, self, logIndex )		

	self.screen.binder.bodyTxtCentral:spoolText(title)
    self.screen.binder.bodyTxt:setText(util.sformat(blurb))

	self.screen.binder.bodyTxt._pageNumber = 0	    
	self.screen.binder.prevBtn.onClick = util.makeDelegate( nil, onClickBioPrev, self, self.screen.binder.nextBtn, self.screen.binder.prevBtn, self.screen.binder.bodyTxt, util.sformat(blurb) )		
	self.screen.binder.nextBtn.onClick =  util.makeDelegate( nil, onClickBioNext, self, self.screen.binder.nextBtn, self.screen.binder.prevBtn, self.screen.binder.bodyTxt )
	
	self.screen.binder.prevBtn:setVisible(false)
	if self.screen.binder.bodyTxt:hasNextPage() then
		self.screen.binder.nextBtn:setVisible(true)
	else
		self.screen.binder.nextBtn:setVisible(false)
	end

	local profile = self.screen.binder.profile 
	if profileImg then
		profile.binder.profileImg:setVisible(true)
		profile.binder.profileAnim:setVisible(false)
		profile.binder.profileImg:setImage(profileImg)
	elseif profileAnim then		
		profile.binder.profileImg:setVisible(false)
		profile.binder.profileAnim:setVisible(true)
		profile.binder.profileAnim:bindBuild( profileBuild or profileAnim )
		profile.binder.profileAnim:bindAnim( profileAnim )
		
		profile.binder.profileAnim:getProp():setRenderFilter( nil )
		profile.binder.profileAnim:setPlayMode( KLEIAnim.LOOP )		
	else
		profile.binder.profileImg:setVisible(false)
		profile.binder.profileAnim:setVisible(false)		
	end
	if footerName then
		local author = STRINGS.UI.DLC_TAG_TYPE_MOD
		if footerAuthor == "Klei" then
			author = STRINGS.UI.DLC_TAG_TYPE_EXPANSION
		end

		self.screen:findWidget("dlcName"):setVisible(true)
		self.screen:findWidget("dlcName"):setText(util.sformat(STRINGS.UI.DLC_TAG,footerName,author))
		--self.screen:findWidget("dlcName"):setTooltip(util.sformat(STRINGS.UI.DLC_TAG,footerName,author))

		-- the icons can be removed with dissabled DLC or mods.. so this will be removed here.
		--[[
		if footerIcon then
			self.screen:findWidget("dlcIcon"):setVisible(true)	
			self.screen:findWidget("dlcIcon"):setImage(footerIcon)
			self.screen:findWidget("dlcIcon"):setTooltip(util.sformat(STRINGS.UI.DLC_TAG,footerName,author))
		end
		]]
	end
end
----------------------------------------------------------------
--

local dialog = class()

function dialog:refreshLog()

	for i=1,#self._unlockedlogs do
		local widget = self.screen.binder.logsList:addItem(self)
		widget.binder.titleTxt2:setText(self._unlockedlogs[i].file)
		widget.binder.btn.onClick = util.makeDelegate( nil, onLogClicked, self,self._unlockedlogs[i], i)
		widget.binder.blankBG:setVisible(false)
	end	

	for i=#self._unlockedlogs+1,13 do
		local widget = self.screen.binder.logsList:addItem(self)
		widget.binder.fileIcon:setVisible(false)
		widget.binder.titleTxt2:setVisible(false)
		widget.binder.blankBG:setVisible(true)
		widget.binder.btn:setVisible(false)
	end		
end

function dialog:refresh()
	self.screen:findWidget("closeBtn").onClick = util.makeDelegate( nil, onClickCloseLog, self)

	self.screen:findWidget("deleteBtn"):setVisible(false)

       

    local user = savefiles.getCurrentGame()				   
   
    if user.data.logs then
    	self._unlockedlogs = user.data.logs
    end

	local profile = self.screen.binder.profile 
	profile.binder.profileImg:setVisible(false)
	profile.binder.profileAnim:setVisible(false)

	self.screen.binder.prevBtn:setVisible(false)
	self.screen.binder.nextBtn:setVisible(false)

    self.screen.binder.bodyTxtCentral:spoolText(STRINGS.UI.SELECT_DATA_LOG)
	self.screen.binder.logsList:clearItems()

	if  self._unlockedlogs and #self._unlockedlogs > 0 then		
		self.screen.binder.bodyTxt:spoolText(STRINGS.UI.DATA_LOGS)
		self.screen.binder.logsList:setVisible(true)
		self:refreshLog()
	else
		self.screen.binder.prevBtn:setVisible(false)
		self.screen.binder.nextBtn:setVisible(false)
		self.screen.binder.bodyTxt:spoolText(STRINGS.UI.NO_DATA_LOGS)	
		self.screen.binder.logsList:setVisible(false)
	end
	
	self.screen:findWidget("dlcName"):setVisible(false)
	self.screen:findWidget("dlcIcon"):setVisible(false)
end

function dialog:show( newLog )

	local screen = mui.createScreen( "modal-logs.lua" )
	self.screen = screen 
	mui.activateScreen( screen )

	screen:createTransition("activate_left")
  
	self:refresh()

	if newLog then
		print("DO SOMETHING WITH A NEW LOG ENTERED")
	end


end

function dialog:destroy()
   
        self.screen:createTransition( "deactivate_left",
            function( transition )
                    mui.deactivateScreen( self.screen )
				    if self.onClose then
				        self.onClose()
				    end
            end,
         { easeOut = true } )      



end


return dialog


