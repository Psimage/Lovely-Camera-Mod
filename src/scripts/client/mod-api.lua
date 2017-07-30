----------------------------------------------------------------
-- Copyright (c) 2015 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local util = include( "modules/util" )
local array = include( "modules/array" )

----------------------------------------------------------------
-- "Official" mod API.
-- This class serves mostly as a self-documenting guide to common mod
-- operations, as well as an indirection layer to maintain a kind of
-- sanity for compatability purposes.




-----------------------------------------------------------------
-- SCRIPT TABLE
-- sometimes a script table is refered to (easy to confuse with mission scripts). 
-- These are used for dialogues between characters at the map screen or in missions.
-- They identify the speaker and what they say. 
-- they are a talbe with these elements:
--        text = string : dictation of what is spoken
--        anim = string : path to the profile animation file of the speaker
--        name = string : the Speaker's name
--        voice = string : path of the sound file





local mod_api = class()

function mod_api:init( mod_manager, mod_id, dataPath, scriptPath )
    self.mod_manager = mod_manager
    self.mod_id = mod_id
    self.data_path = dataPath
    self.script_path = scriptPath
    local modInfo = mod_manager:findMod( mod_id )
    self._dlc_footer = { modInfo.name, modInfo.icon, modInfo.author }    
end

function mod_api:getDataPath()
    return self.data_path
end

function mod_api:getScriptPath()
    return self.script_path
end

---------------------------------------------------------------
--prefabs are bits of level. Arangements of walls, floors and props and match and burn tags.
function mod_api:addPrefabt( prefabt )
    table.insert(self.mod_manager.modPrefabs,prefabt)
end

function mod_api:addWorldPrefabt( path, world, prefabt )                
  --  self.mod_manager.modWorldPrefabs[world] =  prefabt 
    self.mod_manager:addWorldPrefabs(world,prefabt)
end

----------------------------------------------------------------
-- escape_mission is a collection of scripts that handle a lot of the general events that happen on missions. 
-- Speical locations have their own scripts, like the detention center, but it also runs the escpae_mission scritps.
-- This function will take whatever scripts file you added in the modinit and appends them to the base escape_mission scripts.
function mod_api:addEscapeScripts(scripts)
    table.insert(self.mod_manager.modMissionScripts,scripts)
end

----------------------------------------------------------------
--Woldgen has a list of strings that is all of the potential side missions that can show up.
--This function adds a string to that list. 
--The string is used in "escape_mission" script (see above) to determine what extra prefabs need to be added or what 
--speial mission script needs to be run. 
--
-- sidemissions :table 
--      talbe of strings 
function mod_api:addSideMissions( path, sidemissions )
    local worldgen = include( "sim/worldgen" )
    for i,item in ipairs (sidemissions) do
        table.insert(worldgen.SIDEMISSIONS,item)
    end
end

----------------------------------------------------------------
-- Adds a string table to the global STRINGS table.
--
-- modFolder: string
--      Path to the folder containing the translated .po file.
-- tableName: string
--      Name of the sub-table within STRINGS to attach to.
-- stringTable: table
--      Table of localizable strings.

function mod_api:addStrings( poFolder, tableName, stringTable )
    assert( type(tableName) == "string" )
    assert( type(stringTable) == "table" )

    local langMod = self.mod_manager:getLanguageMod()
    if langMod then
        local loc_translator = include( "loc_translator" )
        local poFilepath = string.format( "%s/%s", poFolder, langMod.poFile )
        loc_translator.translateStringTable( tableName, stringTable, poFilepath, langMod.poFile )
    end
    assert( STRINGS[ tableName ] == nil )
    STRINGS[ tableName ] = stringTable
end

---------------------------------------------------------------
-- Scritps in this case are sets of data that say who is talking, the location of the VO sound file, and a string of the dialog
-- This function adds new script lines to the INGAME table. Basically all the in mission speaking. 
-- Scripts can be added without a VO sound, in which case, the message will just show up like the agent's banter.
function mod_api:addMissionScripts(  table )
    assert( type(table) == "table" )

    local SCRIPTS = include('client/story_scripts')    
    for i,tableItem in pairs(table)do
        SCRIPTS.INGAME[i] = tableItem
    end
end


------------------------------------------------------------------------------------
-- this function swaps out a script that exists already for a new one.
--
-- path: a table of the heiarcy in the scripts file of the entry you want to replace. "INCAME.AGENTDOWN" would be {"INGAME","AGENTDOWN"}
-- data: a "SCRIPT" table (see top of file)
function mod_api:modScript( path,data)
    local SCRIPTS = include('client/story_scripts')
    local var = SCRIPTS
    for i, level in ipairs(path)do
        if i == #path then
            var[level] = data
        else
            var = var[level]
        end
    end
end


-------------------------------------------------------------------------------------
-- New scripts for the map screen. Dialogue between missions.
-- table is a list "SCRIPT" tables. (see top of file)
function mod_api:addMapScripts( table, base)
    assert( type(table) == "table" )
    assert( type(base) == "string" )

    local SCRIPTS = include('client/story_scripts')
    for i,tableItem in pairs(table)do
        SCRIPTS[base].MISSIONS[i] = tableItem
    end
end


-------------------------------------------------------------------------------------
-- adds the options that are customizeable to the the generations options screen.
-- option : string
--      the lable of the option, used in the modinit file to actually load or not load certain content.
-- name : string
--      the name the shows up on the campaign generation screen
-- tip : string
--      the text that shows when you roll over that item on the campaign geration screen.
function mod_api:addGenerationOption( option, name, tip)
    assert( type(option) == "string" )
    assert( type(name) == "string" )
    assert( type(tip) == "string" )
    log:write("mod_api[%s]:addGenerationOption( %s, %s )", self.mod_id, option, name)

    self.mod_manager:addGenerationOption(self.mod_id, option, name, tip)
end


---------------------------------------------------------------------------------------
-- add or replace content on the simdefs file. 

function mod_api:addSimdef( entry, content )
    assert( type(entry) == "string" )
    assert( type(content) == "table" )

    local simdefs = include( "sim/simdefs" )

    if rawget(simdefs,entry) then    
       local data = rawget(simdefs,entry) 
       for i,item in pairs(content)do

           data[i]=item
       end             
       rawset(simdefs, entry, data)       
    else
        rawset(simdefs, entry, content or false)
    end
end

----------------------------------------------------------------------------------------
-- replace or add new types of alarm responses
-- These are just the rules of what happens when that alarm state is triggers
-- the list of what alarm states will trigger at each alarm level is in simdefs
function mod_api:addAlarmStates( entry, content )
    assert( type(entry) == "string" )
    assert( type(content) == "table" )

    local alarm_states = include( "sim/alarm_states" )

    if alarm_states[entry] then
        for i,item in pairs(content)do
            alarm_states[entry][i] = item
        end
    else
        alarm_states[entry] = content
    end
end


----------------------------------------------------------------
-- Add/update an prop definition to the official props table.
--
-- FTM has speical props are some of its unique threats, like the FTM scanner or router. For these kinds of props they must have a FTM_PREFABS entry
--
-- name: string
-- propDef: table
-- threats: boolean, if threats for this mod have been enabled, these props need to be added to their corp for worldgen.
function mod_api:addPropDef( name, propDef, threats )
    assert( type(name) == "string" )
    assert( type(propDef) == "table" )
    assert( type(threats) == "boolean" )

    local propdefs = include("sim/unitdefs/propdefs")
    propdefs[ name ] = propDef

    if propDef.traits.recap_icon then
        mod_manager.device_lookup[propDef.id] = propDef.traits.recap_icon
        if array.find( mod_manager.device_types , propDef.traits.recap_icon) == nil then
            table.insert(mod_manager.device_types,propDef.traits.recap_icon)
        end
    end
 
    if threats and propDef.FTM_PREFABS then    
        local worldgen = include( "sim/worldgen" )
        table.insert(worldgen.FTM.PREFABS,propDef.FTM_PREFABS)
    end
    --[[
    if threats and propDef.SANKAKU_PREFABS then    
        local worldgen = include( "sim/worldgen" )
        table.insert(worldgen.SANKAKU.PREFABS,propDef.SANKAKU_PREFABS)
    end

    if threats and propDef.PLASTECH_PREFABS then    
        local worldgen = include( "sim/worldgen" )
        table.insert(worldgen.PLASTECH.PREFABS,propDef.PLASTECH_PREFABS)
    end

    if threats and propDef.KO_PREFABS then    
        local worldgen = include( "sim/worldgen" )
        table.insert(worldgen.KO.PREFABS,propDef.KO_PREFABS)
    end            
    ]]
end

----------------------------------------------------------------
-- Add/update an agent definition to the official agents table.
--
-- NOTE: Each agent needs a completely unique agentID. We used numbers, 
-- but strings may be better as they could have a prefix of your mod name making 
-- it less likely for conflicts. EG: "coolMod-Gary"
--
-- name: string
--      Used as a key to uniquely identify this agentDef in the agent definitions table
-- agentDef: table
--      Defines the agent; see agentdefs.lua
-- loadout: nil or table
--      Array of strings that define the alternate loadouts for this agent.  If no table is provided
--      then this agentDef is not selectable through the team preview screen.

function mod_api:addAgentDef( name, agentDef, loadout )
    assert( type(name) == "string" )
    assert( type(agentDef) == "table" )
    assert( loadout == nil or type(loadout) == "table" )

    local agentdefs = include( "sim/unitdefs/agentdefs" )
    agentdefs[ name ] = agentDef

    if type(loadout) == "table" then
        local serverdefs = include( "modules/serverdefs" )
        if array.find( serverdefs.SELECTABLE_AGENTS, name ) == nil then
            table.insert( serverdefs.SELECTABLE_AGENTS, name )
        end
        serverdefs.LOADOUTS[ name ] = loadout
    end

    if self._dlc_footer then
       agentdefs[ name ].traits.dlcFooter = self._dlc_footer
    end

end

----------------------------------------------------------------
-- Add/update an guard definition to the official guard table.
--
-- Each unit type added needs to know what spawn group it belongs to and what weight chance it has to spawn.  The SPAWN GROUP name will be a nunber of 
-- its weight in that category or nil. 
--      CAMERA_DRONES = each mission reguardless of corp may have 1 or more from this list
--      CORPNANE_THREAT = the unique threats for this corp
--      CORPNAME_LV2 = the leveled up versions of the unique threats that show up later in the game.
--      CORPNAME_GUARD = the lowest level threats for this corp (basic of support guards)
--      SANKAKU_HUMAN_THREAT = Sankaku is special in that it was important to have a distinction between it's human and drone guards to ensure at least  
--                             a few human guards
--      SANKAKU_HUMAN_GUARD = Same as above, Sankaku is speical.
--
-- name: string
--      Used as a key to uniquely identify this agentDef in the agent definitions table
-- guardDef: table
--      Defines the agent; see guarddefs.lua

function mod_api:addGuardDef( name, guardDef )
    assert( type(name) == "string" )
    assert( type(guardDef) == "table" )

    local guarddefs = include( "sim/unitdefs/guarddefs" )
    guarddefs[ name ] = guardDef

    guarddefs[ name ].id = name

    local worldgen = include( "sim/worldgen" )

    -- SPAWN GROUPS
    if guardDef.CAMERA_DRONE then
        worldgen.CAMERA_DRONE[name] = guardDef.CAMERA_DRONE
        table.insert(worldgen.CAMERA_DRONE_FIX,{name,guardDef.CAMERA_DRONE})
    end
    if guardDef.FTM_THREAT then
        worldgen.FTM_THREAT[name] = guardDef.FTM_THREAT
        table.insert(worldgen.FTM.THREAT_FIX,{name,guardDef.FTM_THREAT})
    end
    if guardDef.FTM_GUARD then
        worldgen.FTM_GUARD[name] = guardDef.FTM_GUARD
        table.insert(worldgen.FTM.GUARD_FIX,{name,guardDef.FTM_GUARD})
    end   
    if guardDef.PLASTECH_THREAT then
        worldgen.PLASTECH_THREAT_0_17_5[name] = guardDef.PLASTECH_THREAT
        table.insert(worldgen.PLASTECH.THREAT_FIX,{name,guardDef.PLASTECH_THREAT})
    end 
    if guardDef.PLASTECH_GUARD then
        worldgen.PLASTECH_GUARD[name] = guardDef.PLASTECH_GUARD
        table.insert(worldgen.PLASTECH.GUARD_FIX,{name,guardDef.PLASTECH_GUARD})
    end 
    if guardDef.KO_THREAT then
        worldgen.KO_THREAT[name] = guardDef.KO_THREAT
        table.insert(worldgen.KO.THREAT_FIX,{name,guardDef.KO_THREAT})
    end 
    if guardDef.KO_GUARD then
        worldgen.KO_GUARD[name] = guardDef.KO_GUARD
        table.insert(worldgen.KO.GUARD_FIX,{name,guardDef.KO_GUARD})
    end     
    if guardDef.SANKAKU_THREAT then
        worldgen.SANKAKU_THREAT[name] = guardDef.SANKAKU_THREAT
        table.insert(worldgen.SANKAKU.THREAT_FIX,{name,guardDef.SANKAKU_THREAT})
    end     
    if guardDef.SANKAKU_HUMAN_THREAT then
        worldgen.SANKAKU_HUMAN_THREAT[name] = guardDef.SANKAKU_HUMAN_THREAT
        table.insert(worldgen.SANKAKU.HUMAN_THREAT_FIX,{name,guardDef.SANKAKU_HUMAN_THREAT})
    end    
    if guardDef.SANKAKU_GUARD then
        worldgen.SANKAKU_GUARD[name] = guardDef.SANKAKU_GUARD
        table.insert(worldgen.SANKAKU.GUARD_FIX,{name,guardDef.SANKAKU_GUARD})
    end        
    if guardDef.SANKAKU_HUMAN_GUARD then
        worldgen.SANKAKU_HUMAN_GUARD[name] = guardDef.SANKAKU_HUMAN_GUARD
        table.insert(worldgen.SANKAKU.HUMAN_GUARD_FIX,{name,guardDef.SANKAKU_HUMAN_GUARD})
    end        
    if guardDef.OMNI_GUARD then
        worldgen.OMNI_GUARD[name] = guardDef.OMNI_GUARD
        table.insert(worldgen.OMNI_GUARD_FIX,{name,guardDef.OMNI_GUARD})
    end 

    if guardDef.FTM_LV2 then
       table.insert(worldgen.FTM.LVL2,{name,guardDef.FTM_LV2})
    end 
    if guardDef.SANKAKU_LV2 then
        table.insert(worldgen.SANKAKU.LVL2,{name,guardDef.SANKAKU_LV2})
    end 
    if guardDef.KO_LV2 then
        table.insert(worldgen.KO.LVL2,{name,guardDef.KO_LV2})
    end 
    if guardDef.PLASTECH_LV2 then
        table.insert(worldgen.PLASTECH.LVL2,{name,guardDef.PLASTECH_LV2})
    end            
   
    if self._dlc_footer then
       guarddefs[ name ].traits.dlcFooter = self._dlc_footer
    end

    if guardDef.traits.recap_icon then
        mod_manager.guard_lookup[name] = guardDef.traits.recap_icon
        if array.find( mod_manager.guard_types, guardDef.traits.recap_icon) == nil then
            table.insert(mod_manager.guard_types,guardDef.traits.recap_icon)
        end
    end


end

----------------------------------------------------------------
-- Add prgrams to the list of starting generators and breakers. 
-- program: string
--      the name of the program to add

function mod_api:addStartingGenerator( program )
    assert( type(program) == "string" )
    local serverdefs = include( "modules/serverdefs" )   
    table.insert(serverdefs.SELECTABLE_PROGRAMS[1],program)  
end
function mod_api:addStartingBreaker( program )
    assert( type(program) == "string" )
    local serverdefs = include( "modules/serverdefs" )   
    table.insert(serverdefs.SELECTABLE_PROGRAMS[2],program)  
end



----------------------------------------------------------------
-- Add agents to the list of rescueable agents
-- unitDef: table
--      id : int
--          agentID from agentDefs
--      template : string
--          agents templateName eg: "sharpshooter_1"
--      upgrades : table
--          table of strings that are the item IDs    

function mod_api:addRescueAgent( unitDef )
    assert( type(unitDef) == "table" )

    local serverdefs = include( "modules/serverdefs" )   
    table.insert(serverdefs.TEMPLATE_AGENCY.unitDefsPotential,unitDef)  
end 


----------------------------------------------------------------
-- Add situations to the list of situations
-- situation: table
--      levelFile : string
--          the name of the map file or procedural generation instructions file
--      ui : table
--          table of strings needed for the map screen ui
--      strings : table
--          table of strings that are used in the mission
--      scripts : table
--          table of strings that are the mission script files used for the mission
--      tags: table
--          table of strings that are special tags for the mission

function mod_api:addSituation( situation, id, path )
    assert( type(situation) == "table" )
    assert( type(situation.levelFile) == "string" )

    local serverdefs = include( "modules/serverdefs" ) 
    situation.scriptPath = path .."/"
    serverdefs.SITUATIONS[id] = situation
end 


-----------------------------------------------------mo-----------
-- Add a program or agent unlock to the XP rewards unlockables. 
--      table of properties of the reward 
--          unlocktype: int     
--                  the type of unlock, 2:agent or 1:program
--          alt: bool
--                  wether the agents unlocked are alts 
--          unlocks: table
--                  nested list of tables with a name property of the unlocked items
--                  {{name="agent"},{name="agent"}}
--                  {{name="program"},{name="progam"}}
--          XP: int
--                  The XP added to the last unlockable needed to reach this item.

function mod_api:addLevelReward( reward )
    assert( type(reward) == "table" )    
    local metadefs = include( "sim/metadefs" )
    local rewardNum = 1
    while metadefs.LEVEL_REWARDS[rewardNum] do 
        rewardNum = rewardNum + 1
    end
    metadefs.XP_LEVELS[rewardNum] = metadefs.XP_LEVELS[rewardNum-1] + (reward.XP or metadefs.XP_INCREMENT3)    
    metadefs.LEVEL_CAP =  #metadefs.XP_LEVELS
    table.insert(metadefs.LEVEL_REWARDS,reward)
end

----------------------------------------------------------------
-- Add a program or agent unlock to be rewarded when DLC installed
-- rewards: table 
--      talbe of reward elements.
-- reward element: table
--      table of properties of the reward 
--          unlocktype: int     
--                  the type of unlock, 2:agent or 1:program
--          alt: bool
--                  wether the agents unlocked are alts 
--          unlocks: table
--                  nested list of tables with a name property of the unlocked items
--                  {{name="agent"},{name="agent"}}
--                  {{name="program"},{name="progam"}}

function mod_api:addInstallReward( reward )
    assert( type(reward) == "table" )    
    local metadefs = include( "sim/metadefs" )
    table.insert(metadefs.DLC_INSTALL_REWARDS, reward)

    local stateGenerationOptions = include( "states/state-generation-options" )

    for _,list in ipairs(metadefs.DLC_INSTALL_REWARDS) do
        if list.unlockType == metadefs.AGENT_UNLOCK then
            for i,unlock in ipairs(list.unlocks) do
                table.insert(stateGenerationOptions._CHARACTER_IMAGES, { png=unlock.png, unlock=unlock.name} )
            end
        end
    end

end

----------------------------------------------------------------
-- Add/update an incognita programe definition to the official program table.
-- name: string
--      Used as a key to uniquely identify this programdef in the program definitions table
-- ability: table
--      Defines the program; see mainframe_abilities.lua

function mod_api:addMainframeAbility( name, ability )
    assert( type(name) == "string" )
    assert( type(ability) == "table" ) 
    local mainframe_abilities = include( "sim/abilities/mainframe_abilities" )    
    mainframe_abilities[ name ] = ability   

    local simstore = include( "sim/units/store" )

    if ability.PROGRAM_LIST then
        simstore.STORE_ITEM.progList:addChoice( name, ability.PROGRAM_LIST ) 
    end

    if ability.PROGRAM_NO_BREAKER_LIST then
        simstore.STORE_ITEM.noBreakerProgList:addChoice( name, ability.PROGRAM_NO_BREAKER_LIST ) 
    end

    if ability.PROGRAM_BEGINNING_BREAKER_LIST then
        simstore.STORE_ITEM.beginner_breakers:addChoice( name, ability.PROGRAM_BEGINNING_BREAKER_LIST ) 
    end 

    if ability.PROGRAM_BEGINNING_NO_BREAKER_LIST then
        simstore.STORE_ITEM.beginner_nobreakers:addChoice( name, ability.PROGRAM_BEGINNING_NO_BREAKER_LIST ) 
    end     

    if self._dlc_footer then
        mainframe_abilities[ name ].dlcFooter = self._dlc_footer
    end   
end

----------------------------------------------------------------
-- Add/update an daemon programe definition to the official daemons table.
-- name: string
--      Used as a key to uniquely identify this daemondef in the daemon definitions table
-- ability: table
--      Defines the Daemon; see npc_abilities.lua

function mod_api:addDaemonAbility( name, ability )
    assert( type(name) == "string" )
    assert( type(ability) == "table" ) 
    local npc_abilities = include( "sim/abilities/npc_abilities" )    
    npc_abilities[ name ] = ability 

    local serverdefs = include( "modules/serverdefs" )
    local worldgen = include( "sim/worldgen" )

    if ability.ENDLESS_DAEMONS then
        table.insert(serverdefs.ENDLESS_DAEMONS,name)
    end
    if ability.PROGRAM_LIST then
        table.insert(serverdefs.PROGRAM_LIST,name)
    end
    if ability.OMNI_PROGRAM_LIST_EASY then
        table.insert(serverdefs.OMNI_PROGRAM_LIST_EASY,name)
    end   
    if ability.OMNI_PROGRAM_LIST then
        table.insert(serverdefs.OMNI_PROGRAM_LIST,name)
    end 
    if ability.REVERSE_DAEMONS then
        table.insert(serverdefs.REVERSE_DAEMONS,name)
    end 

    if self._dlc_footer then
        npc_abilities[ name ].dlcFooter = self._dlc_footer
    end
end

----------------------------------------------------------------
-- Add/update an animation definitions to the official anims table.
-- name: string
--      Used as a key to uniquely identify this animation in the item animdefs table
-- animDef: table
--      Defines the animation; see animdefs.lua

function mod_api:addAnimDef( name, animDef )
    assert( type(name) == "string" )
    assert( type(animDef) == "table" ) 

    local animdefs = include( "animdefs" )     
    animdefs.defs[ name ] = animDef
end

----------------------------------------------------------------
-- Add/update an item definition to the official itemdefs table.
-- name: string
--      Used as a key to uniquely identify this itemDef in the item definitions table
-- itemDef: table
--      Defines the item; see itemdefs.lua

function mod_api:addItemDef( name, itemDef )
    assert( type(name) == "string" )
    assert( type(itemDef) == "table" )

    local itemdefs = include( "sim/unitdefs/itemdefs" )
    itemdefs[ name ] = itemDef
    itemdefs[ name ].id = name

    local simstore = include( "sim/units/store" )

    if itemDef.ITEM_LIST then
        table.insert(simstore.STORE_ITEM.itemList,itemDef)
    end
    if itemDef.WEAPON_LIST then
        table.insert(simstore.STORE_ITEM.weaponList,itemDef)
    end
    if itemDef.AUGMENT_LIST then
        table.insert(simstore.STORE_ITEM.augmentList,itemDef)
    end   

    if self._dlc_footer then
        itemdefs[ name ].traits.dlcFooter = self._dlc_footer
    end
end

----------------------------------------------------------------
-- Add/update an ability definition to the official abilitydefs table.
-- name: string
--      Used as a key to uniquely identify this itemDef in the item definitions table
-- itemDef: table
--      Defines the item; see itemdefs.lua

function mod_api:addAbilityDef( name, abilityDefPath )
    assert( type(name) == "string" )
    assert( type(abilityDefPath) == "string" )

    local abilitydefs = include( "sim/abilitydefs" )
    abilitydefs._abilities[ name ] = include( abilityDefPath )
end


----------------------------------------------------------------
-- Insert a new custom final situation so that it will add it to new campaigns if the extended campaign is selected
-- situation: table
--      table of the parameters serverdefs uses to create the new final situation
--              name: string
--                      name of the new situation
--              corp: string
--                       name of the corp the mission we be set in. 

function mod_api:setCampaignEvent_CustomFinalSituation( situation )
    assert( type(situation) == "table" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.CUSTOM_FINAL,
        data = situation,    
    }    
    mod_manager:setCampaignEvent(event)       
end


----------------------------------------------------------------
-- trigger more hours to be added to the campaign when a certain mission is finished
--              hours: number
--                      hours to add
--              triggerMission: string
--                      name of mission to trigger. 

function mod_api:setCampaignEvent_AddMoreHours( hours, triggerMission )
    assert( type(hours) == "number" )
    assert( type(triggerMission) == "string" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.ADD_MORE_HOURS,
        mission = triggerMission,
        data = hours,    
    }    
    mod_manager:setCampaignEvent(event)         
end


----------------------------------------------------------------
-- trigger to advance to the next day in a campaign after a certain mission is finished
--              triggerMission: string
--                      name of mission to trigger. 

function mod_api:setCampaignEvent_AdvanceADay( triggerMission )
    assert( type(triggerMission) == "string" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.ADVANCE_TO_NEXT_DAY,
        mission = triggerMission,  
    }    
    mod_manager:setCampaignEvent(event)         
end


----------------------------------------------------------------
-- trigger to set a set if custom scripts on the map screen after a certain mission is finished
--              customIndex: string
--                      name of the new script ID prefix to use
--              triggerMission: string
--                      name of mission to trigger. 

function mod_api:setCampaignEvent_SetCustomScriptIndex( customIndex,triggerMission )
    assert( type(customIndex) == "string" )
    assert( type(triggerMission) == "string" )

    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.SET_CUSTOM_SCRIPT_INDEX,
        mission = triggerMission,  
        data = customIndex,
    }    
    mod_manager:setCampaignEvent(event)         
end

----------------------------------------------------------------
-- trigger to start a particular mission right after a certain mission is finished
--              mission: string
--                      name of next mission
--              triggerMission: string
--                      name of mission to trigger. 

function mod_api:setCampaignEvent_AddSequelMisison( missionData, triggerMission )
    assert( type(missionData) == "table" )
    assert( type(triggerMission) == "string" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.GOTO_MISSION,
        mission = triggerMission,
        data = missionData,    
    }    
    mod_manager:setCampaignEvent(event)       
end

----------------------------------------------------------------
-- trigger have a popup show up on the map screen after a particular mission
--              popUpData: table
--                      table of data to populate the pop up 
--              triggerMission: string
--                      name of mission to trigger. 

function mod_api:setCampaignEvent_AddMapPopup( popUpData, triggerMission, hours )
    assert( type(popUpData) == "table" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.ADD_POPUP,
        mission = triggerMission,
        data = popUpData, 
        hours = hours,   
    }    
    mod_manager:setCampaignEvent(event)       
end

----------------------------------------------------------------
-- trigger to add campaign params after a certain mission is finished
--              triggerMission: string
--                      name of mission to trigger.             
--              param: string
--                      param to add

function mod_api:setCampaignEvent_setCampaignParam( triggerMission, param, value, agency, editCampaign, hours)
    --if triggerMission is nil, this will happen at the begining of the campaign    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.SET_CAMPAIGN_PARAM,        
        mission = triggerMission,   
        data = {param=param, value=value, agency=agency, editCampaign=editCampaign, hours=hours },        
    }    
    mod_manager:setCampaignEvent(event)       
end

----------------------------------------------------------------
-- trigger to remove an agent 
--              triggerMission: string
--                      name of mission to trigger. 
--              agent: number
--                      ID of agent to remove. 

function mod_api:setCampaignEvent_setRemoveAgent( triggerMission, agent )
    assert( type(triggerMission) == "string" )
    assert( type(agent) == "number" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.REMOVE_AGENT,
        mission = triggerMission,   
        data = agent,
    }    
    mod_manager:setCampaignEvent(event)       
end

----------------------------------------------------------------
-- trigger to remove an agent 
--              triggerMission: string
--                      name of mission to trigger. 
--              agent: number
--                      ID of agent to remove. 

function mod_api:setCampaignEvent_setAddAgent( triggerMission, agent, removeMission )
    assert( type(triggerMission) == "string" )
    assert( type(agent) == "number" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
        eventType = simdefs.CAMPAIGN_EVENTS.ADD_AGENT,
        mission = triggerMission,   
        data = {agent = agent, removeMission = removeMission},
    }    
    mod_manager:setCampaignEvent(event)       
end

----------------------------------------------------------------
-- sets a mission to override the situations on the map for endless mode
--              day: number
--                      day the mission is inserted
--              mission: string
--                     name of the mission
function mod_api:setCampaignEvent_setAddEndlessMission( day, mission )
    assert( type(day) == "number" )
    assert( type(mission) == "string" )
    
    local simdefs = include( "sim/simdefs" )
    
    local event = {
       eventType = simdefs.CAMPAIGN_EVENTS.ADD_ENDLESS_MISSION,
       mission = mission,
       day = day,
    }    
    mod_manager:setCampaignEvent(event)       
end

------------------------------------------------------------
-- adds world geneartion code to worldgen
--          world: table
--                  the wold generation code
function mod_api:addCorpWorld( worldID, world )
    assert( type(worldID) == "string" )
    assert( type(world) == "table" )
    
    local worldgen = include( "sim/worldgen" )
    
    worldgen.worlds[worldID] = world
end

------------------------------------------------------------
-- increases the max difficulty of endless missions
function mod_api:changeMaxLocationDifficulty( maxDiff )
    local serverdefs = include( "modules/serverdefs" )
    serverdefs.MAX_DIFFICULTY.MAX= maxDiff
end

------------------------------------------------------------
-- set ENDLESS alert daemon start time.
function mod_api:changeAlerEndlessDay( day )
    local serverdefs = include( "modules/serverdefs" )
    serverdefs.ENDLESS_ALERT_DAYS.DAY= day
end

function mod_api:addAchievement( achievement )
   self.mod_manager:addAchievement(achievement)
end

function mod_api:addLog( log )
    local serverdefs = include( "modules/serverdefs" )

    log.footerName = self._dlc_footer[1]
    log.footerIcon = self._dlc_footer[2]
    log.footerAuthor = self._dlc_footer[3]

    table.insert(serverdefs.LOGS,log)
    print("ADDING LOG")
end

function mod_api:addTooltipDef( commondef )

    if commondef.onMainframeTooltip then
        table.insert(self.mod_manager:getTooltipDefs().onMainframeTooltips, commondef.onMainframeTooltip)
    end
    if commondef.onGuardTooltip then
        table.insert(self.mod_manager:getTooltipDefs().onGuardTooltips, commondef.onGuardTooltip)
    end
    if commondef.onAgentTooltip then
        table.insert(self.mod_manager:getTooltipDefs().onAgentTooltips, commondef.onAgentTooltip)
    end
    if commondef.onItemTooltip then
        table.insert(self.mod_manager:getTooltipDefs().onItemTooltips, commondef.onItemTooltip)
    end
    if commondef.onItemWorldTooltip then
        table.insert(self.mod_manager:getTooltipDefs().onItemWorldTooltips, commondef.onItemWorldTooltip)
    end
                
end



return mod_api