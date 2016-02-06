Hooks:PostHook( HUDHitConfirm , "init" , "uHUDPostHUDHitConfirmInit" , function( self , hud )

	if self._hud_panel:child( "headshot_confirm" ) then
		self._hud_panel:remove( self._hud_panel:child( "headshot_confirm" ) )
	end
	
	self._headshot_confirm = self._hud_panel:bitmap({
		valign 			= "center",
		halign 			= "center",
		visible 		= false,
		name 			= "headshot_confirm",
		texture		 	= "guis/textures/pd2/hud_radial_rim",
		color 			= uHUD:HasSetting( "headshot_colour" ) and Color( uHUD:HasSetting( "headshot_colour" ) ) or Color.red,
		w 				= 20,
		h 				= 20,
		layer 			= 1,
		blend_mode 		= "add"
	})
	
	self._headshot_confirm:set_center( self._hud_panel:w() / 2 , self._hud_panel:h() / 2 )

end )

Hooks:PostHook( HUDHitConfirm , "on_headshot_confirmed" , "uHUDPostHUDHitConfirmOnHeadshotConfirmed" , function( self )

	self._headshot_confirm:stop()
	self._headshot_confirm:animate( callback( self , self , "_animate_show" ) , callback( self , self , "show_done" ) , 0.25 )

end )