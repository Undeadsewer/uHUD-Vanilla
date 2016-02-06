Hooks:PostHook( ContractBoxGui , "create_character_text" , "uHUDPostContractBoxGuiCreateCharacterText" , function( self , peer_id , x , y , text , icon )

	if not peer_id or not managers.network:session() then
		return
	end
	
	if not managers.network:session():peer( peer_id ) then
		return
	end
	
	if not uHUD:HasSetting( "lobby_character_name" ) then
		return
	end
	
	local character = managers.localization:text( "menu_" .. managers.network:session():peer( peer_id ):character() )
	
	self._peers[ peer_id ]:set_text( text and ( character .. " | " .. text ) or "" )
	
	self._peers[ peer_id ]:set_range_color( 0 , string.len( character ) , Color.white )
	self._peers[ peer_id ]:set_range_color( string.len( character ) , string.len( character ) + 3 , Color.white:with_alpha( 0.5 ) )
	
	local _, _, w, h = self._peers[ peer_id ]:text_rect()
	self._peers[ peer_id ]:set_size( w , h )
	self._peers[ peer_id ]:set_center( x , y )
	
	if icon then
		local texture = tweak_data.hud_icons:get_icon_data( "infamy_icon" )
		self._peers_icon = self._peers_icon or {}
		self._peers_icon[ peer_id ] = self._peers_icon[ peer_id ] or self._panel:bitmap({
			w 		= 16,
			h 		= 32,
			texture = texture,
			color 	= tweak_data.chat_colors[ peer_id ]
		})
		self._peers_icon[ peer_id ]:set_right( self._peers[ peer_id ]:x() )
		self._peers_icon[ peer_id ]:set_top( self._peers[ peer_id ]:y() )
	elseif self._peers_icon and self._peers_icon[ peer_id ] then
		self._panel:remove( self._peers_icon[ peer_id ] )
		self._peers_icon[ peer_id ] = nil
	end

end )