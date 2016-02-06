_G.uHUD = _G.uHUD or {}

uHUD.ModPath = ModPath
uHUD.SavePath = SavePath .. "uHUDTweakData.txt"
uHUD.Options = uHUD.Options or {}
uHUD.Menu = "uHUDMenu"

-- \\ You can add your own custom colours here! Just add the following: { "<colour name>" , "<HEX colour code>" } | EXAMPLE: { "Valencia" , "DB3D3D" }, // --
-- \\ 						This website should help you find and name custom colours: http://chir.ag/projects/name-that-color/ 						// --
-- \\ 						PLEASE NOTE: Don't forget to add a comma at the end of the bracket UNLESS it's the last on the list!! 						// --
uHUD.ColorTables = {

	{ "White" , "FFFFFF" },
	{ "Red" , "FF0000" },
	{ "Orange" , "FF8000" },
	{ "Yellow" , "FFFF00" },
	{ "Lime Green" , "80FF00" },
	{ "Green" , "00FF00" },
	{ "Spring Green" , "00FF80" },
	{ "Light Blue" , "0080FF" },
	{ "Blue" , "0000FF" },
	{ "Violet" , "7F00FF" },
	{ "Gray" , "808080" }

}

local HookFiles = {

	[ "lib/managers/hudmanagerpd2" ] 							= "lib/hudmanagerpd2.lua",
	[ "lib/managers/hudmanager" ] 								= "lib/hudmanager.lua",
	[ "lib/managers/hud/hudhitconfirm" ] 						= "lib/hudhitconfirm.lua",
	[ "lib/managers/hud/hudinteraction" ] 						= "lib/hudinteraction.lua",
	[ "lib/managers/hud/hudmissionbriefing" ] 					= "lib/hudmissionbriefing.lua",
	[ "lib/managers/hud/hudstageendscreen" ] 					= "lib/hudstageendscreen.lua",
	[ "lib/managers/hud/hudsuspicion" ] 						= "lib/hudsuspicion.lua",
	[ "lib/managers/hud/hudteammate" ] 							= "lib/hudteammate.lua",
	[ "lib/units/beings/player/huskplayermovement" ] 			= "lib/huskplayermovement.lua",
	[ "lib/units/equipment/ammo_bag/ammobagbase" ] 				= "lib/ammobagbase.lua",
	[ "lib/units/equipment/bodybags_bag/bodybagsbagbase" ] 		= "lib/bodybagsbagbase.lua",
	[ "lib/units/props/carrydata" ] 							= "lib/carrydata.lua",
	[ "lib/units/equipment/grenade_crate/grenadecratebase" ] 	= "lib/grenadecratebase.lua",
	[ "lib/managers/menu/contractboxgui" ] 						= "lib/contractboxgui.lua",
	[ "lib/units/enemies/cop/copdamage" ] 						= "lib/copdamage.lua",
	[ "lib/units/equipment/doctor_bag/doctorbagbase" ] 			= "lib/doctorbagbase.lua",
	[ "lib/managers/menumanagerdialogs" ] 						= "lib/menumanagerdialogs.lua",
	[ "lib/managers/menu/missionbriefinggui" ] 					= "lib/missionbriefinggui.lua",
	[ "lib/units/beings/player/playerdamage" ] 					= "lib/playerdamage.lua",
	[ "lib/units/beings/player/playermovement" ] 				= "lib/playermovement.lua",
	[ "lib/units/beings/player/states/playerstandard" ] 		= "lib/playerstandard.lua",
	[ "lib/managers/statisticsmanager" ] 						= "lib/statisticsmanager.lua",
	[ "lib/units/props/timergui" ] 								= "lib/timergui.lua",
	[ "lib/network/handlers/unitnetworkhandler" ] 				= "lib/unitnetworkhandler.lua"
	
}

function uHUD:Save()

	local data = io.open( self.SavePath , "w+" )
	
	if data then
		data:write( json.encode( self.Options ) )
		data:close()
	end
	
end

function uHUD:Load()

	local data = io.open( self.SavePath , "r" )
	
	if data then
		self.Options = json.decode( data:read( "*all" ) )
		data:close()
	end
	
end

function uHUD:DefaultSettings()

	for i , option in ipairs( self.ToggleOptions ) do
		self.Options[ option ] = self.Options[ option ] or false
	end
	
	for i , option in ipairs( self.ColorOptions ) do
		self.Options[ option ] = self.Options[ option ] or "FFFFFF"
	end
	
	self:Save()

end

function uHUD:HasSetting( setting )

	return uHUD.Options[ setting ] or false
	
end

function uHUD:ConvertToRGB( hue , saturation , value )
 
	local red, grn, blu

	local i = math.floor( hue * 6 )
	local f = hue * 6 - i
	local p = value * ( 1 - saturation )
	local q = value * ( 1 - f * saturation )
	local t = value * ( 1 - ( 1 - f ) * saturation )

	local m = i % 6
	if m == 0 then
		red = value
		grn = t
		blu = p
	elseif m == 1 then
		red = q
		grn = value
		blu = p
	elseif m == 2 then
		red = p
		grn = value
		blu = t
	elseif m == 3 then
		red = p
		grn = q
		blu = value
	elseif m == 4 then
		red = t
		grn = p
		blu = value
	elseif m == 5 then
		red = value
		grn = p
		blu = q
	end

	return red , grn , blu

end

Hooks:Add( "MenuManagerSetupCustomMenus" , "uHUDPostMenuManagerSetupCustomMenus" , function( self , nodes )
    
	MenuHelper:NewMenu( uHUD.Menu )
	
	for i , data in ipairs( uHUD.MenuOptions ) do
		MenuHelper:NewMenu( data )
	end
	
end )

Hooks:Add( "LocalizationManagerPostInit" , "uHUDPostLocalizationManagerInit" , function( self )

	local function AddMenu( data )
		
		self:add_localized_strings({
		
			[ "uHUD_" .. data[ 1 ] .. "_t" ] = data[ 2 ],
			[ "uHUD_" .. data[ 1 ] .. "_d" ] = data[ 3 ]
			
		})
		
		uHUD.MenuOptions = uHUD.MenuOptions or {}
		table.insert( uHUD.MenuOptions , data[ 1 ] )
	
	end
	
	local function AddToggle( data )
	
		self:add_localized_strings({
		
			[ "uHUD_" .. data[ 1 ] .. "_t" ] = data[ 2 ],
			[ "uHUD_" .. data[ 1 ] .. "_d" ] = data[ 3 ]
		
		})
		
		uHUD.ToggleOptions = uHUD.ToggleOptions or {}
		table.insert( uHUD.ToggleOptions , data )
	
	end
	
	local function AddColor( data )
	
		self:add_localized_strings({
		
			[ "uHUD_" .. data[ 1 ] .. "_t" ] = data[ 2 ],
			[ "uHUD_" .. data[ 1 ] .. "_d" ] = data[ 3 ]
		
		})
		
		uHUD.ColorOptions = uHUD.ColorOptions or {}
		table.insert( uHUD.ColorOptions , data )
	
	end
	
	self:add_localized_strings({
		[ "uHUDt" ] = "uHUD Vanilla+",
		[ "uHUDd" ] = "Expand your vanilla HUD experience!"
	})
	
	for i , color in ipairs( uHUD.ColorTables ) do
	
		self:add_localized_strings({ [ "uHUD_Color" .. i ] = color[ 1 ] })
		
		uHUD.Colors = uHUD.Colors or {}
		table.insert( uHUD.Colors , "uHUD_Color" .. i )
		
	end
	
	-- \\ ADD MENU // --
	
	AddMenu({
		"uPlayerAndTeam",
		"Player/Teammate Panel",
		"HUD options that affect both your panel and teammate panels."
	})
	
	AddMenu({
		"uPlayer",
		"Player Panel",
		"HUD options that affect your player panel."
	})
	
	AddMenu({
		"uTeammate",
		"Teammate Panel",
		"HUD options that affect your teammate panels."
	})
	
	AddMenu({
		"uWorldWorkspace",
		"World Workspace",
		"HUD options that affect any 3D world workspace environments."
	})
	
	AddMenu({
		"uMiscellaneous",
		"Miscellaneous",
		"HUD options that affect various aspects of the mod."
	})
	
	-- \\ TOGGLE OPTIONS // --
	
	AddToggle({
		"coloured_name",
		"Coloured Names",
		"Displays everyone's name based on their colour. (e.g Host = Green)",
		"uPlayerAndTeam"
	})
	
	AddToggle({
		"infamy_callsign",
		"Infamy Callsign",
		"Displays an infamy icon instead of a circle next to a player's name if they are infamied.",
		"uPlayerAndTeam"
	})
	
	AddToggle({
		"infamy_rank",
		"Infamy Rank",
		"Displays a player's infamy rank instead of a circle next their name if they are infamied.",
		"uPlayerAndTeam"
	})
	
	AddToggle({
		"player_rank",
		"Rank on Player Name",
		"Displays a player's infamy and level next to their name in-game. (e.g \"Undeadsewer (XXV-100)\")",
		"uPlayerAndTeam"
	})
	
	AddToggle({
		"stamina",
		"Stamina Counter",
		"Displays your current stamina inside your health circle.",
		"uPlayer"
	})
	
	AddToggle({
		"stamina_warning",
		"Low Stamina Warning",
		"Displays a flashing red circle to indicate when your stamina is below 25%.",
		"uPlayer"
	})
	
	AddToggle({
		"downed_counter",
		"Downed Counter",
		"Displays how many downs you have until you get into custody.",
		"uPlayer"
	})
	
	AddToggle({
		"downed_counter_teammate",
		"Teammate Downed Counter",
		"Displays how many times your teammates have been downed.",
		"uTeammate"
	})
	
	AddToggle({
		"health_warning",
		"Health Warning",
		"Displays a flashing red circle in your health circle to indicate when your health is below 20%.",
		"uPlayer"
	})
	
	AddToggle({
		"health_warning_teammate",
		"Teammate Health Warning",
		"Displays a flashing red circle in your teammate's health circle to indicate when their health is below 20%.",
		"uTeammate"
	})
	
	AddToggle({
		"mask",
		"Player Mask",
		"Displays your current mask inside your health circle.",
		"uPlayer"
	})
	
	AddToggle({
		"mask_teammate",
		"Teammate Mask",
		"Displays your teammate's mask inside their health circle.",
		"uTeammate"
	})
	
	AddToggle({
		"true_ammo",
		"True Ammo",
		"Displays the current ammo instead of the total ammo.",
		"uPlayer"
	})
	
	AddToggle({
		"full_ammo",
		"Full Ammo Indicator",
		"Displays the total ammo count in a custom colour to indicate that you have full ammo.",
		"uPlayer"
	})
	
	AddToggle({
		"animated_total_ammo",
		"Animated Total Ammo",
		"Displays an animated count when you gain ammo.",
		"uPlayer",
	})
	
	AddToggle({
		"animated_current_mag",
		"Animated Current Magazine",
		"Displays an animated count when you reload your magazine.",
		"uPlayer"
	})
	
	AddToggle({
		"underdog",
		"Underdog Indicator",
		"Displays a flashing yellow glow when the Underdog skill is activated.",
		"uPlayer"
	})
	
	AddToggle({
		"enemy_health",
		"Enemy Health Overlay",
		"Displays a health bar and the enemy's name when aiming at them.",
		"uMiscellaneous"
	})
	
	AddToggle({
		"timers",
		"World Timers",
		"Displays a non-intrusive timer next to drills, computers, etc.",
		"uWorldWorkspace"
	})
	
	AddToggle({
		"damage_text",
		"Damage Texts",
		"Displays a non-intrusive value next to enemies who receive damage.",
		"uWorldWorkspace"
	})
	
	AddToggle({
		"kill_counter",
		"Kill Counter",
		"Displays a text counter which tracks current kills of your equipped weapon and total kills.",
		"uPlayer"
	})
	
	AddToggle({
		"lobby_character_name",
		"Character Names in Lobby",
		"Displays the player's character name in the lobby alongside their name.",
		"uMiscellaneous"
	})
	
	AddToggle({
		"detection_concealment",
		"Detection Meter Concealment",
		"Displays your concealment value when the detection meter is visible.",
		"uMiscellaneous"
	})
	
	AddToggle({
		"detection_percent",
		"Detection Meter Percentage",
		"Displays your detection percentage when the detection meter is visible.",
		"uMiscellaneous"
	})
	
	AddToggle({
		"interact_timer",
		"Interacting Timers",
		"Displays a timer inside your interacting circle while interacting.",
		"uPlayer"
	})
	
	AddToggle({
		"interact_timer_teammate",
		"Teammate Interacting Timers",
		"Displays a mini-timer inside your teammate's health circle while they are interacting.",
		"uTeammate"
	})
	
	AddToggle({
		"interaction_text_teamamte",
		"Teammate Interaction Text",
		"Displays the action text of your teammates while they are interacting.",
		"uTeammate"
	})
	
	AddToggle({
		"armour_timer",
		"Armour Regen Timer",
		"Displays a timer which indicates how long until your armour regenerates.",
		"uPlayer"
	})
	
	AddToggle({
		"headshot",
		"Headshot Hitmarker",
		"Displays a coloured circle around the hitmarker to indicate a headshot.",
		"uPlayer"
	})
	
	AddToggle({
		"reload_timer",
		"Reloading Timers",
		"Displays a non-intrusive timer inside your ammo count which indicates how long your reloading time is.",
		"uPlayer"
	})
	
	AddToggle({
		"coloured_bag",
		"Coloured Bag Icons",
		"Displays a coloured bag on top of a teammate's health circle instead of white.",
		"uPlayerAndTeam"
	})
	
	AddToggle({
		"deployable",
		"Deployable Amount Texts",
		"Displays a non-intrusive value on deployables which indicate the amount it currently has.",
		"uWorldWorkspace"
	})
	
	AddToggle({
		"no_interact_circle",
		"Remove Interact Circle",
		"Displays no interact circle while interacting. This should only be enabled if you have Interacting Timers enabled!",
		"uPlayer"
	})
	
	AddToggle({
		"carry",
		"Carry Info",
		"Displays a non-intrusive text on bags/interactables which identify the type of loot. (e.g. Jewelry, Gold, etc.)",
		"uWorldWorkspace"
	})
	
	-- \\ COLOUR OPTIONS // --
	
	AddColor({
		"headshot_colour",
		"Hitmarker Colour",
		"Change the colour of the headshot hitmarker.",
		"uPlayer"
	})
	
	AddColor({
		"full_ammo_colour",
		"Full Ammo Colour",
		"Change the colour when your total ammo is full.",
		"uPlayer"
	})
	
	AddColor({
		"damage_skull_colour",
		"Damage Skull Colour",
		"Change the colour of the skull when the damage text is visible.",
		"uWorldWorkspace"
	})
	
	AddColor({
		"kill_counter_colour",
		"Kill Counter Colour",
		"Change the colour of the kill counter.",
		"uPlayer"
	})
	
	AddColor({
		"timers_colour",
		"W. Timer Colour",
		"Change the colour of the world-space timers.",
		"uWorldWorkspace"
	})
	
	AddColor({
		"timers_jammed_colour",
		"W.T. Jammed Colour",
		"Change the colour of the world-space timers when they are jammed.",
		"uWorldWorkspace"
	})
	
	AddColor({
		"deployable_colour",
		"Deployable Colour",
		"Change the colour of the deployable amount texts.",
		"uWorldWorkspace"
	})
	
	AddColor({
		"carry_colour",
		"Carry Info Colour",
		"Change the colour of the carry info texts.",
		"uWorldWorkspace"
	})
	
	uHUD:Load()
	uHUD:DefaultSettings()

end )

Hooks:Add( "MenuManagerBuildCustomMenus" , "uHUDPostMenuManagerBuildCustomMenus" , function( self , nodes )

    nodes[ uHUD.Menu ] = MenuHelper:BuildMenu( uHUD.Menu )
    MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu , uHUD.Menu , "uHUDt" , "uHUDd" )
	
	for i , data in ipairs( uHUD.MenuOptions ) do
	
		nodes[ data ] = MenuHelper:BuildMenu( data )
		MenuHelper:AddMenuItem( nodes[ uHUD.Menu ] , data , "uHUD_" .. data .. "_t" , "uHUD_" .. data .. "_d" )
	
	end
	
end )

Hooks:Add( "MenuManagerPopulateCustomMenus" , "uHUDPostMenuManagerPopulateCustomMenus" , function( self , nodes )
	
	for i , data in ipairs( uHUD.ToggleOptions ) do
	
		MenuCallbackHandler[ data[ 1 ] .. "_toggle" ] = function( self , item )
			uHUD.Options[ data[ 1 ] ] = ( item:value() == "on" and true or nil )
			uHUD:Save()
		end
		
		MenuHelper:AddToggle({
			id 			= "uHUD_" .. data[ 1 ] .. "_toggle",
			title 		= "uHUD_" .. data[ 1 ] .. "_t",
			desc 		= "uHUD_" .. data[ 1 ] .. "_d",
			callback 	= data[ 1 ] .. "_toggle",
			menu_id 	= data[ 4 ],
			value 		= uHUD.Options[ data[ 1 ] ]
		})
	
	end
	
	for i , data in ipairs( uHUD.ColorOptions ) do
	
		local function FindColourIndex( colour )
		
			for i , data in ipairs( uHUD.ColorTables ) do
				if data[ 2 ] == colour then return i end
			end
			return 1
		
		end
	
		MenuCallbackHandler[ data[ 1 ] .. "_colour" ] = function( self , item )
			uHUD.Options[ data[ 1 ] ] = uHUD.ColorTables[ item:value() ][ 2 ]
			uHUD:Save()
		end
		
		MenuHelper:AddMultipleChoice({
			id 			= "uHUD_" .. data[ 1 ] .. "_colour",
			title 		= "uHUD_" .. data[ 1 ] .. "_t",
			desc 		= "uHUD_" .. data[ 1 ] .. "_d",
			callback 	= data[ 1 ] .. "_colour",
			items 		= uHUD.Colors,
			menu_id 	= data[ 4 ],
			value 		= FindColourIndex( uHUD.Options[ data[ 1 ] ] ),
		})
	
	end

end )

if RequiredScript then

	local requiredScript = RequiredScript:lower()
	
	if HookFiles[ requiredScript ] then
		dofile( uHUD.ModPath .. HookFiles[ requiredScript ] )
	end
	
end