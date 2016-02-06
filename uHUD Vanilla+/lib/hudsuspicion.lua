Hooks:PostHook( HUDSuspicion , "init" , "uHUDPostHUDSuspicionInit" , function( self , hud , sound_source )

	local concealment_value = self._suspicion_panel:text({
		name 		= "concealment_value",
		text 		= "0",
		blend_mode 	= "add",
		alpha 		= 1,
		visible 	= uHUD:HasSetting( "detection_concealment" ) and true or false,
		w 			= self._suspicion_panel:w() / 2,
		h 			= self._suspicion_panel:h() / 2,
		valign 		= "center",
		halign 		= "center",
		font 		= "fonts/font_medium_mf",
		font_size 	= 28,
		color 		= tweak_data.hud.prime_color,
		vertical 	= "top",
		align 		= "center",
		layer 		= 1
	})
	
	concealment_value:set_center( self._suspicion_panel:w() / 2 , self._suspicion_panel:h() / 2 )
	
	local detection_value = self._suspicion_panel:text({
		name 		= "detection_value",
		text 		= "0%",
		blend_mode 	= "add",
		alpha 		= 1,
		visible 	= uHUD:HasSetting( "detection_percent" ) and true or false,
		w 			= self._suspicion_panel:w() / 2,
		h 			= self._suspicion_panel:h() / 2,
		valign 		= "center",
		halign 		= "center",
		font 		= "fonts/font_medium_mf",
		font_size 	= 28,
		color 		= tweak_data.hud.suspicion_color,
		vertical 	= "bottom",
		align 		= "center",
		layer 		= 1
	})
	
	detection_value:set_center( self._suspicion_panel:w() / 2 , self._suspicion_panel:h() / 2 )

end )

Hooks:PreHook( HUDSuspicion , "show" , "uHUDPreHUDSuspicionShow" , function( self )

	local function ConcealmentColour( detection_risk )
	
		if detection_risk >= 63 then
			return tweak_data.hud.detected_color
		elseif detection_risk <= 58 and detection_risk > 23 then
			return tweak_data.hud.prime_color
		else
			return tweak_data.hud.suspicion_color
		end
	
	end

	local detection_risk = managers.blackmarket:get_suspicion_offset_of_local( tweak_data.player.SUSPICION_OFFSET_LERP or 0.75 )
	detection_risk = math.round( detection_risk * 100 )
	
	self._suspicion_panel:child( "concealment_value" ):set_color( ConcealmentColour( detection_risk ) )
	self._suspicion_panel:child( "concealment_value" ):set_text( tostring( detection_risk ) .. "" )

end )

Hooks:PreHook( HUDSuspicion , "feed_value" , "uHUDPreHUDSuspicionFeedValue" , function( self , value )

	self._suspicion_panel:child( "detection_value" ):set_color( tweak_data.hud.detected_color * ( value / 1 ) + tweak_data.hud.suspicion_color * ( 1 - value / 1 ) )
	self._suspicion_panel:child( "detection_value" ):set_text( string.format( "%.0f" , ( value / 1 ) * 100 ) .. "%" )

end )