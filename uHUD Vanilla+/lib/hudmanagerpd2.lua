function HUDManager:get_panel_by_peer_id( peer_id )

	for panel , data in pairs( self._teammate_panels ) do
		if data._peer_id == peer_id then
			return panel
		end
	end

end

function HUDManager:get_panel_by_mugshot_id( mug_id )

	for i , criminal in pairs( managers.criminals:characters() ) do
		if criminal.data.mugshot_id == mug_id then
			return criminal.data.panel_id
		end
	end

end

Hooks:PreHook( HUDManager , "set_stamina_value" , "uHUDPostHUDManagerSetStaminaValue" , function( self , value )

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:set_stamina_value( value )

end )

Hooks:PreHook( HUDManager , "set_max_stamina" , "uHUDPostHUDManagerSetMaxStamina" , function( self , value )

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:set_max_stamina( value )

end )

Hooks:PostHook( HUDManager , "set_mugshot_voice" , "uHUDPostHUDManagerSetMugshotVoice" , function( self , id , active )

	local panel_id = self:get_panel_by_mugshot_id( id )
	
	if not panel_id then return end
	self._teammate_panels[ panel_id ]:set_voice( active )

end )

function HUDManager:update_downed_counter( value )

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:set_downed( value )
	
end

function HUDManager:show_underdog()

	if not uHUD:HasSetting( "underdog" ) then
		self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_underdog()
		return
	end
	
	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:show_underdog()

end

function HUDManager:hide_underdog()

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_underdog()

end

function HUDManager:show_armor_timer( time )

	if not uHUD:HasSetting( "armour_timer" ) then
		self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_armor_timer()
		return
	end
	
	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:show_armor_timer( time )

end

function HUDManager:hide_armor_timer()

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_armor_timer()

end

function HUDManager:show_reload_timers( index , time )

	if not uHUD:HasSetting( "reload_timer" ) then
		self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_reload_timers( index )
		return
	end
	
	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:show_reload_timers( index , time )

end

function HUDManager:hide_reload_timers( index )

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:hide_reload_timers( index )

end

function HUDManager:update_kill_counter( weapon , total )

	self._teammate_panels[ HUDManager.PLAYER_PANEL ]:update_kill_counter( weapon , total )

end

function HUDManager:sync_doctor_bag_taken( panel )

	self._teammate_panels[ panel ]:sync_doctor_bag_taken()

end

function HUDManager:on_peer_downed( panel )

	self._teammate_panels[ panel ]:on_peer_downed()

end