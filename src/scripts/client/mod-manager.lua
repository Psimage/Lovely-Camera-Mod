----------------------------------------------------------------
-- Copyright (c) 2015 Klei Entertainment Inc.
-- All Rights Reserved.
-- SPY SOCIETY.
----------------------------------------------------------------

local util = include( "modules/util" )
local filesystem = include("modules/filesystem")

local MOD_FOLDER = "mods"
local DLC_FOLDER = "dlc"



----------------------------------------------------------------
-- Mod handling

local mod_manager = class()

function mod_manager:init( mod_path )    
    self.mod_path = mod_path or ""
    self.mods = {}
    self.modPrefabs = {}
    self.modMissionScripts = {}
    self.modWorldPrefabs = {}
    self.generationOptions = {}

    self.achievements = {}

    --init summary screen mod updates
    self.device_types = {}
    self.guard_types = {}
    self.credit_sources = {}
    self.credit_sinks = {}
    self.device_lookup = {}
    self.guard_lookup = {}

    self.toolTipDefs_DEFAULT = {
        onAgentTooltips={},
        onItemWorldTooltips ={},
        onItemTooltips = {},
        onGuardTooltips = {},
        onMainframeTooltips = {},
    }

    self.toolTipDefs = {
        onAgentTooltips={},
        onItemWorldTooltips ={},
        onItemTooltips = {},
        onGuardTooltips = {},
        onMainframeTooltips = {},
    }

    filesystem.mountVirtualDirectory( "data_locale", "data" ) -- By default, simply map directly to data.

    self:enumerateDLC( self.mod_path .. DLC_FOLDER )
    self:enumerateMods( self.mod_path .. MOD_FOLDER )
end

function mod_manager:updateMods()
    if not KLEISteamWorkshop then
        return
    end

    log:write( "Updating mods..." )
    KLEISteamWorkshop:setListener( KLEISteamWorkshop.EVENT_REFRESH_COMPLETE,
        function( success, msg )
            log:write("KLEISteamWorkshop.EVENT_REFRESH_COMPLETE - (%s, %s)", success and "succeeded" or "failed", msg )

            self:clearMods()
            self:enumerateMods( self.mod_path .. MOD_FOLDER )
        end )
    -- Kick off the call to refresh mods.
    KLEISteamWorkshop:updateWorkshopMods()
end

function mod_manager:mountMods()
    log:write("Mounting mods...")

    for i, mod in ipairs(self.mods) do
        if not mod.locale then
            self:mountContentModPrelocalize( mod.id )
        end
    end  

    local settings = savefiles.getSettings( "settings" )
    log:write("Language selection: ", settings.data.localeMod)
    if settings.data.localeMod then
        self:mountLanguageMod( settings.data.localeMod )
    end
    
    for i, mod in ipairs(self.mods) do
        if not mod.locale then
            self:mountContentMod( mod.id )
        end
    end
end

function mod_manager:enumerateMods( enum_folder )

    log:write("Mod manager enumerating mods [%s]", enum_folder)

    local fsMods = MOAIFileSystem.listDirectories( enum_folder ) or {}
    for i, path in ipairs( fsMods ) do
        local modData = {}
        modData.id = path
        modData.folder = filesystem.pathJoin( enum_folder, path )

        log:write("Found mod [%s] in [%s]", modData.id, modData.folder)

        self:initMod( modData )
    end
end

function mod_manager:enumerateDLC( enum_folder )

    log:write("Mod manager enumerating dlc [%s]", enum_folder)

    local fsMods = MOAIFileSystem.listDirectories( enum_folder ) or {}
    for i, path in ipairs( fsMods ) do
        local modData = {}
        modData.id = path
        modData.folder = filesystem.pathJoin( enum_folder, path )
        modData.is_dlc = true
        modData.dlc_owned = not KLEISteamWorkshop or KLEISteamWorkshop:ownsDLC(path)

        log:write("Found dlc [%s] in [%s] %s", modData.id, modData.folder, modData.dlc_owned and "owned" or "installed")

        self:initMod( modData )
    end
end

function mod_manager:initMod( modData )
    log:write( "initMod - %s", modData.folder )

    local initFile = filesystem.pathJoin( modData.folder, "modinfo.txt" )

    -- Find the specified locale in modinit.
    local fl = io.open( initFile, "r" )
    if fl then
        local modinfo = {}
	    for line in fl:lines() do
            local key, value = line:match( "^([_%w]+)[%s]*=[%s]*(.-)%s*$" )
            if key and value then
                modinfo[key] = value
                log:write( "\tproperty: [%s] = [%s]", tostring(key), tostring(value) )
            end
        end

        if modinfo.name then
            log:write( "\tNAME: %s", tostring(modinfo.name) )
            modData.name = modinfo.name
        end

        if modinfo.icon then
            log:write( "\tICON: %s", tostring(modinfo.name) )
            modData.icon = modinfo.icon
        end

        if modinfo.author then
            log:write( "\tAUTHOR: %s", tostring(modinfo.name) )
            modData.author = modinfo.author
        end        

        if modinfo.locale then
            log:write( "\tLOCALE: %s", tostring(modinfo.locale) )
            modData.locale = modinfo.locale
        end

        if modinfo.poFile then
            log:write( "\tPOFILE: %s", tostring(modinfo.poFile) )
            modData.poFile = modinfo.poFile
        end

        table.insert( self.mods, modData )
        
    elseif MOAIFileSystem.checkFileExists( filesystem.pathJoin( modData.folder, "scripts.zip" )) then
        table.insert( self.mods, modData )
    else
        log:write( "\tMissing '%s' -- ignoring.", initFile )
    end
end

function mod_manager:mountContentModPrelocalize( id )
    local modData = self:findMod( id )
    if not modData then
        log:write( "Could not mount missing content mod: '%s'", tostring(id) )
    elseif not MOAIFileSystem.checkFileExists( filesystem.pathJoin( modData.folder, "scripts.zip" )) then
        log:write( "Could not mount content mod without scripts.zip: '%s'", tostring(id) )
    else
        -- Mount the content archive.
        local scriptsArchive = string.format( "%s/scripts.zip", modData.folder, modData.scripts )
        local scriptsAlias = scriptsArchive:match( "/([-_%w]+)/scripts[.]zip$" )

        log:write( "Pre localization mounting for content mod [%s] scripts at: [%s]", tostring(scriptsArchive), tostring(scriptsAlias)  )
        MOAIFileSystem.mountVirtualDirectory( scriptsAlias, scriptsArchive )

        local initFile = string.format( "%s/modinit.lua", scriptsAlias )
        log:write( "\tExecuting pre localization '%s':", initFile )

        local res = false
        local ok, mod = pcall( dofile, initFile )
        if ok then
            if mod.initStrings then

                modData.modfn = mod

                ok, res = xpcall(
                    function()
                        local modapi = reinclude( "mod-api" )
                        modData.api = modapi( self, id, modData.folder, scriptsAlias )
                        modData.modfn.initStrings( modData.api )
                    end,
                    function( err )
                        log:write( "mod.initStrings ERROR: %s\n%s", tostring(err), debug.traceback() )
                    end )
            else
                log:write( "\tMOD-NO INITSTRINGS FUNCTION PRESENT")
            end
        end
        
        if ok then
            log:write( "\tMOD-INITSTRINGS OK")
            -- Anything here to finalize mod content?
        else
            if not res then
                res = "pcall failed"
            end
            log:write( "\tMOD-INITSTRINGS FAILED: %s", tostring(res))
        end          

    end
end

function mod_manager:mountContentMod( id )
    local modData = self:findMod( id )
    if not modData then
        log:write( "Could not mount missing content mod: '%s'", tostring(id) )
    elseif not MOAIFileSystem.checkFileExists( filesystem.pathJoin( modData.folder, "scripts.zip" )) then
        log:write( "Could not mount content mod without scripts.zip: '%s'", tostring(id) )
    else
        -- Mount the content archive.
        local scriptsArchive = string.format( "%s/scripts.zip", modData.folder, modData.scripts )
        local scriptsAlias = scriptsArchive:match( "/([-_%w]+)/scripts[.]zip$" )

        log:write( "Mounting content mod [%s] scripts at: [%s]", tostring(scriptsArchive), tostring(scriptsAlias)  )
        MOAIFileSystem.mountVirtualDirectory( scriptsAlias, scriptsArchive )

        local initFile = string.format( "%s/modinit.lua", scriptsAlias )
        log:write( "\tExecuting '%s':", initFile )
        local ok, mod = pcall( dofile, initFile )
        if ok then
            modData.modfn = mod

            assert(modData.modfn.init)
            assert(modData.modfn.load)                        

            ok, res = xpcall(
                function()
                    local modapi = reinclude( "mod-api" )
                    modData.api = modapi( self, id, modData.folder, scriptsAlias )

                    modData.modfn.init( modData.api )
                end,
                function( err )
                    log:write( "mod.init ERROR: %s\n%s", tostring(err), debug.traceback() )
                end )
        end
        if ok then
            log:write( "\tMOD-INIT OK")
            -- Anything here to finalize mod content?
            modData.installed = true
        else
            log:write( "\tMOD-INIT FAILED: %s", tostring(res))
            modData.installed = false
        end
    end
end


function mod_manager:mountLanguageMod( id )
    local modData = self:findMod( id )
    if not modData then
        log:write( "Could not mount missing language mod: '%s'", tostring(id) )
    elseif not modData.locale then
        log:write( "Could not mount non-language mod: '%s'", tostring(id) )
    elseif not modData.poFile then
        log:write( "Could not language mod without specified 'poFile': '%s'", tostring(id) )
    else
        log:write( "Mounting language mod: %s ['data-locale' -> '%s']", modData.locale, modData.folder )    
        filesystem.mountVirtualDirectory( "data_locale", modData.folder )
        local loc_translator = include( "loc_translator" )
        local poFilepath = string.format( "%s/%s", modData.folder, modData.poFile )
        loc_translator.translateStringTable( "STRINGS", STRINGS, poFilepath, modData.locale )
        self.languageMod = modData
    end
end

function mod_manager:getLanguageMod()
    return self.languageMod
end

function mod_manager:clearMods()
    for i=#self.mods,1,-1 do
        local modData = self.mods[i]
        if not modData.is_dlc then
            table.remove(self.mods, i)
        end
    end
end

function mod_manager:findMod( id )
    for i, modData in ipairs(self.mods) do
        if modData.id == id and id then
            return modData
        end
    end
end

function mod_manager:getLanguageMods()
    local t = {}
    for i, modData in ipairs(self.mods) do
        if modData.locale then
            table.insert( t, { name = modData.locale, id = modData.id } )
        end
    end
    return t
end


function mod_manager:hasContentMods()
    for i, modData in ipairs(self.mods) do
        if not modData.is_dlc and not modData.locale then
            return true
        end
    end
    return false
end

function mod_manager:isDLCOptionEnabled(modID,option)
   local modData = self:findMod( modID )
    
    if modData and modData.options then
        return modData.options[option] and modData.options[option].enabled
    end
end

function mod_manager:getInstalledMods()
    local t = {}
    for i, modData in ipairs(self.mods) do
        if modData.installed and (not modData.is_dlc or modData.dlc_owned) then
            assert( modData.id )
            table.insert( t, modData.id )
        end
    end
    return t
end

function mod_manager:isInstalled( id )
    local modData = self:findMod( id )
    return modData and modData.installed
end

function mod_manager:getModName( id )
    local modData = self:findMod( id )
    return modData and (modData.name or "ID:"..modData.id)
end

function mod_manager:getModIcon( id )
    local modData = self:findMod( id )
    return modData and modData.icon and modData.icon
end


function mod_manager:getAchievments( )
    return self.achievements
end

function mod_manager:addAchievement( achievement )
   print("ADD ACHIEVEMENT",achievement.achievementID)
   table.insert( self.achievements, achievement )
end

function ResetCampaignEvents(self)
    self.campaignEvents = {}
end


function mod_manager:getTooltipDefs()
    return  self.toolTipDefs
end

function ResetTooltipDefs(self)
    util.tclear(self.toolTipDefs.onAgentTooltips)
    util.tmerge(self.toolTipDefs.onAgentTooltips, self.toolTipDefs_DEFAULT.onAgentTooltips)

    util.tclear(self.toolTipDefs.onItemWorldTooltips)
    util.tmerge(self.toolTipDefs.onItemWorldTooltips, self.toolTipDefs_DEFAULT.onItemWorldTooltips)

    util.tclear(self.toolTipDefs.onItemTooltips)
    util.tmerge(self.toolTipDefs.onItemTooltips, self.toolTipDefs_DEFAULT.onItemTooltips)

    util.tclear(self.toolTipDefs.onGuardTooltips)
    util.tmerge(self.toolTipDefs.onGuardTooltips, self.toolTipDefs_DEFAULT.onGuardTooltips)

    util.tclear(self.toolTipDefs.onMainframeTooltips)
    util.tmerge(self.toolTipDefs.onMainframeTooltips, self.toolTipDefs_DEFAULT.onMainframeTooltips)
end


function mod_manager:resetContent()
    local worldgen = include( "sim/worldgen" )

    log:write("mod_manager:resetContent()")
    ResetAgentDefs()
    ResetItemDefs()
    ResetGuardDefs()
    ResetProgramDefs()
    ResetDaemonDefs()
    ResetAgentLoadouts()
    ResetSelectableAgents()
    ResetSelectablePrograms()
    ResetDaemonAbilities()
    ResetStoreItems()
    ResetMetaDefs()
    ResetUnitDefsPotential()
    ResetSituations()
    ResetCampaignEvents(self)
    ResetStoryScripts()
    ResetPropDefs()
    ResetGuardsWorldGen()
    ResetTooltipDefs(self)
end

function mod_manager:loadModContent( dlc_options )
    
    self.modPrefabs = {}
    self.modMissionScripts = {}

    --log:write("mod_manager:loadModContent(%s)", util.stringize(dlc_options))    
    if dlc_options then
        for id,dlc in pairs(dlc_options) do
            --log:write("   %s %s: %s", id, dlc.name, tostring(dlc.enabled))
            if dlc.enabled then
                local modData = self:findMod( id )
                modData.modfn.load(modData.api, dlc.options)
            end
        end
    end
end


function mod_manager:setCampaignEvent(event)
    table.insert(self.campaignEvents,event)
end
 
function mod_manager:getCampaignEvents()
    return self.campaignEvents
end

function mod_manager:addGenerationOption( mod_id, option, name, tip)
    local modData = self:findMod(mod_id)

    if not modData.is_dlc or modData.dlc_owned then
        if not self.generationOptions[mod_id] then
            self.generationOptions[mod_id] = { name = self:getModName(mod_id), enabled = true, options = {}, icon=self:getModIcon(mod_id) }
        end

        local new_opt = { option = option, name = name, enabled = true, tip = tip}
        table.insert(self.generationOptions[mod_id].options, new_opt)
    end
end

function mod_manager:getModContentDefaults()
    --log:write("mod_manager:getModContentDefaults")

    local options = util.tcopy(self.generationOptions)

    -- convert from array (for order) to keyed (for save game)
    for mod_id, mod_info in pairs(options) do
        local keyed_options = {}
        for i, opt_info in ipairs(mod_info.options) do
            keyed_options[opt_info.option] = { enabled = opt_info.enabled }
        end
        mod_info.options = keyed_options
    end

    --log:write("   %s", util.stringize(options))

    return options
end

function mod_manager:getModGenerationOptions( mod_id )
    return util.tcopy(self.generationOptions[mod_id].options)
end


function mod_manager:addWorldPrefabs( world , prefabs )
    self.modWorldPrefabs[world] = prefabs 
end


return mod_manager
