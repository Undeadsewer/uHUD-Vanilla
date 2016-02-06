Hooks:PostHook( PlayerDamage , "update" , "uHUDPostPlayerDamageUpdate" , function( self , unit , t , dt )

	if self:got_messiah_charges() then
		managers.hud:update_downed_counter( self._messiah_charges .. "/" .. tostring( Application:digest_value( self._revives , false ) - 1 ) )
	else
		managers.hud:update_downed_counter( tostring( Application:digest_value( self._revives , false ) - 1 ) )
	end
	
	if self._regenerate_timer then
		managers.hud:show_armor_timer( self._regenerate_timer )
	else
		managers.hud:hide_armor_timer()
	end

end )