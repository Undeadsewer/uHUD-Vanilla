Hooks:PostHook( HUDInteraction , "init" , "uHUDPostHUDInteractionInit" , function( self , hud , child_name )

	self._child_name_interact = ( child_name or "interact" ) .. "_timer"
	
	if self._hud_panel:child( self._child_name_interact ) then self._hud_panel:remove( self._hud_panel:child( self._child_name_interact ) ) end
	
	local interact_timer = self._hud_panel:text({
		name 		= self._child_name_interact,
		visible 	= false,
		text 		= "0s",
		blend_mode 	= "add",
		alpha 		= 1,
		w 			= self._hud_panel:w() / 2,
		h 			= self._hud_panel:h() / 2,
		valign 		= "center",
		halign 		= "center",
		font 		= "fonts/font_medium_shadow_mf",
		font_size 	= 40,
		color 		= Color.white,
		vertical 	= "center",
		align 		= "center",
		layer 		= 2
	})
	
	interact_timer:set_center( self._hud_panel:w() / 2 , self._hud_panel:h() / 2 )

end )

Hooks:PostHook( HUDInteraction , "show_interact" , "uHUDPostHUDInteractionShowInteract" , function( self , data )

	self._last_text = data.text
	
end )

Hooks:PostHook( HUDInteraction , "show_interaction_bar" , "uHUDPostHUDInteractionShowInteractionBar" , function( self , current , total )

	if not self._interact_circle then
		return
	end
	
	if uHUD:HasSetting( "no_interact_circle" ) then
		self._interact_circle:set_visible( false )
	end
	
	self._hud_panel:child( self._child_name_interact ):set_visible( uHUD:HasSetting( "interact_timer" ) and true or false )
	
	if self._last_text and utf8.to_upper( self._last_text ) == "YOU ARE BEING HELPED UP" then return end
	
	if managers.interaction:active_unit() and managers.interaction:active_unit():interaction() and managers.interaction:active_unit():interaction()._tweak_data and managers.interaction:active_unit():interaction()._tweak_data.action_text_id then
		self._action_text_id = utf8.to_upper( managers.localization:text( managers.interaction:active_unit():interaction()._tweak_data.action_text_id ) )
		self._hud_panel:child( self._child_name_text ):set_text( self._action_text_id )
	else
		self._action_text_id = utf8.to_upper( managers.localization:text( "hud_action_generic" ) )
		self._hud_panel:child( self._child_name_text ):set_text( self._action_text_id )
	end

end )

Hooks:PostHook( HUDInteraction , "set_interaction_bar_width" , "uHUDPostHUDInteractionSetInteractionBarWidth" , function( self , current , total )

	if not self._hud_panel:child( self._child_name_interact ) then return end
	
	local value = ( total - current ) < 0 and 0 or ( total - current )
	
	self._hud_panel:child( self._child_name_interact ):set_alpha( 1 )
	
	self._hud_panel:child( self._child_name_interact ):set_text( string.format( "%.1f" , value ) .. "s" )
	self._hud_panel:child( self._child_name_interact ):set_color( ( tweak_data.chat_colors[ 1 ] * ( current / total ) ) + ( Color.white * ( 1 - ( current / total ) ) ) )

end )

Hooks:PostHook( HUDInteraction , "hide_interaction_bar" , "uHUDPostHUDInteractionHideInteractionBar" , function( self , complete )

	if self._hud_panel:child( self._child_name_interact ) and not complete then
		self._hud_panel:child( self._child_name_interact ):set_visible( false )
	elseif uHUD:HasSetting( "interact_timer" ) and self._hud_panel:child( self._child_name_interact ) and complete then
		self._hud_panel:child( self._child_name_interact ):animate( callback( self , self , "_animate_timer_complete" ) )
	end
	
	if self._last_text then
		self._hud_panel:child( self._child_name_text ):set_text( utf8.to_upper( self._last_text ) )
	end
	
	if self._action_text_id then self._action_text_id = nil end

end )

Hooks:PreHook( HUDInteraction , "_animate_interaction_complete" , "uHUDPostHUDInteractionAnimateInteractionComplete" , function( self , bitmap , circle )

	if uHUD:HasSetting( "no_interact_circle" ) then
		bitmap:set_visible( false )
		circle:set_visible( false )
	end

end )

function HUDInteraction:_animate_timer_complete( timer )

	local TOTAL_T = 0.6
	local t = TOTAL_T
	local mul = 1
	local c_x , c_y = timer:center()
	local size = timer:w()
	local font_size = timer:font_size()
	
	while t > 0 do
	
		local dt = coroutine.yield()
		
		t = t - dt
		mul = mul + dt * 0.75
		
		timer:set_size( size * mul , size * mul )
		timer:set_font_size( font_size * mul )
		timer:set_center( c_x , c_y )
		timer:set_alpha( math.max( t / TOTAL_T , 0 ) )
	
	end
	
	timer:set_visible( false )
	
	timer:set_font_size( 40 )
	timer:set_color( Color.white )
	timer:set_size( self._hud_panel:w() / 2 , self._hud_panel:h() / 2 )
	timer:set_center( self._hud_panel:w() / 2 , self._hud_panel:h() / 2 )

end