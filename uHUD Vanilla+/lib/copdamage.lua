Hooks:PreHook( CopDamage , "_on_damage_received" , "uHUDPreCopDamageOnDamageReceived" , function( self , damage_info )
		
	if self._uws and alive( self._uws ) then
		self._uws:panel():stop()
		World:newgui():destroy_workspace( self._uws )
		self._uws = nil
	end
	
	self._uws = World:newgui():create_world_workspace( 165 , 100 , self._unit:movement():m_head_pos() + Vector3( 0 , 0 , 70 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	self._uws:set_billboard( self._uws.BILLBOARD_BOTH )
	
	local panel = self._uws:panel():panel({
		visible = uHUD:HasSetting( "damage_text" ) and true or false,
		name 	= "damage_panel",
		layer 	= 0
	})
	
	local text = panel:text({
		text 		= string.format( damage_info.damage * 10 >= 10 and "%d" or "%.1f" , damage_info.damage * 10 ),
		layer 		= 1,
		align 		= "left",
		vertical 	= "bottom",
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 70,
		color 		= Color.white
	})
	
	local attacker_unit = damage_info and damage_info.attacker_unit
	
	if alive( attacker_unit ) and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end
	
	if attacker_unit and managers.network:session() and managers.network:session():peer_by_unit( attacker_unit ) then
		local peer_id = managers.network:session():peer_by_unit( attacker_unit ):id()
		local c = tweak_data.chat_colors[ peer_id ]
		text:set_color( c )
	end
	
	if damage_info.result.type == "death" then
		text:set_text( managers.localization:get_default_macro( "BTN_SKULL" ) .. text:text() )
		text:set_range_color( 0 , 1 , uHUD:HasSetting( "damage_skull_colour" ) and Color( uHUD:HasSetting( "damage_skull_colour" ) ) or Color.red )
	end
	
	panel:animate( function( p )
		over( 5 , function( o )
			self._uws:set_world( 165 , 100 , self._unit:movement():m_head_pos() + Vector3( 0 , 0 , 70 ) + Vector3( 0 , 0 , math.lerp( 0 , 50 , o ) ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
			text:set_color( text:color():with_alpha( 0.5 + ( math.sin( o * 750 ) + 0.5 ) / 4 ) )
			panel:set_alpha( math.lerp( 1 , 0 , o ) )
		end )
		panel:remove( text )
		World:newgui():destroy_workspace( self._uws )
	end )

end )

Hooks:PreHook( CopDamage , "damage_bullet" , "uHUDPreCopDamageDamageBullet" , function( self , attack_data )

	if self._dead then return end
	if not attack_data.attacker_unit or attack_data.attacker_unit and attack_data.attacker_unit ~= managers.player:player_unit() then return end
	
	local body = attack_data.body_name or attack_data.col_ray.body:name()
	
	if uHUD:HasSetting( "headshot" ) and body:key() then
	
		if body:key() == Idstring( "head" ):key() or body:key() == Idstring( "hit_Head" ):key() or body:key() == Idstring( "rag_Head" ):key() then
			managers.hud:on_headshot_confirmed()
		end
		
	end

end )

Hooks:PreHook( CopDamage , "damage_melee" , "uHUDPreCopDamageDamageMelee" , function( self , attack_data )

	if self._dead then return end
	if not attack_data.attacker_unit or attack_data.attacker_unit and attack_data.attacker_unit ~= managers.player:player_unit() then return end
	
	local body = attack_data.body_name or attack_data.col_ray.body:name()
	
	if uHUD:HasSetting( "headshot" ) and body:key() then
	
		if body:key() == Idstring( "head" ):key() or body:key() == Idstring( "hit_Head" ):key() or body:key() == Idstring( "rag_Head" ):key() then
			managers.hud:on_headshot_confirmed()
		end
		
	end

end )

Hooks:PostHook( CopDamage , "destroy" , "uHUDPostCopDamageDestroy" , function( self , ... )

	if self._uws and alive( self._uws ) then
		World:newgui():destroy_workspace( self._uws )
		self._uws = nil
	end

end )