Hooks:PostHook( PlayerStandard , "_update_reload_timers" , "uHUDPostPlayerStandardUpdateReloadTimers" , function( self , t , dt , input )

	if self._state_data.reload_expire_t then
		managers.hud:show_reload_timers( self._equipped_unit:base():selection_index() , ( self._state_data.reload_expire_t - t ) )
	else
		managers.hud:hide_reload_timers( self._equipped_unit:base():selection_index() )
	end

end )

Hooks:PostHook( PlayerStandard , "_update_fwd_ray" , "uHUDPostPlayerStandardUpdateFwdRay" , function( self )

	if not uHUD:HasSetting( "enemy_health" ) then
		managers.hud:set_unit_health_visible( false )
		return
	end
	
	if self._last_unit then
	
		local iAngle = 360
		local cAngle = 360
		
		iAngle = self:getUnitRotation( self._last_unit )
		
		if iAngle then
			
			cAngle = cAngle + ( iAngle - cAngle )
			
			if cAngle == 0 then cAngle = 360 end
		
			managers.hud:set_unit_health_rotation( cAngle )
			
		end
		
	end
	
	if self._fwd_ray and self._fwd_ray.unit then
	
		local unit = self._fwd_ray.unit
		
		if unit:in_slot( 8 ) and alive( unit:parent() ) then
			unit = unit:parent()
		end
		
		if managers.groupai:state():turrets() then
			for _ , t_unit in pairs( managers.groupai:state():turrets() ) do
				if alive( t_unit ) and t_unit:movement():team().foes[ managers.player:player_unit():movement():team().id ] and unit == t_unit then
					unit = t_unit
				end
			end
		end
		
		if alive( unit ) and unit:character_damage() and not unit:character_damage()._dead and not managers.enemy:is_civilian( unit ) and managers.enemy:is_enemy( unit ) and unit:base() and unit:base()._tweak_table then
			
			self._last_unit = unit
			managers.hud:set_unit_health_visible( true )
			managers.hud:set_unit_health( unit:character_damage()._health or 0 , unit:character_damage()._HEALTH_INIT or 0 , unit:base()._tweak_table or "cop" )
			
		else
		
			if self._last_unit and alive( self._last_unit ) then
				managers.hud:set_unit_health( self._last_unit:character_damage()._health or 0 , self._last_unit:character_damage()._HEALTH_INIT or 0 , self._last_unit:base()._tweak_table or "cop" )
				managers.hud:set_unit_health_visible( false )
				return
			end
			
		end
		
	else
	
		if self._last_unit and alive( self._last_unit ) then
			managers.hud:set_unit_health( self._last_unit:character_damage()._health or 0 , self._last_unit:character_damage()._HEALTH_INIT or 0 , self._last_unit:base()._tweak_table or "cop" )
			managers.hud:set_unit_health_visible( false )
			return
		end
		
	end

end )

Hooks:PostHook( PlayerStandard , "_update_check_actions" , "uHUDPostPlayerStandardUpdateCheckActions" , function( self , t , dt )

	if self._camera_unit:base()._melee_item_units then
	
		managers.hud:update_kill_counter( managers.statistics:session_killed_by_melee() , managers.statistics:session_total_kills() )
		
	elseif not self._camera_unit:base()._melee_item_units then
		
		managers.hud:update_kill_counter( managers.statistics:session_killed_by_weapon( self._ext_inventory:equipped_unit():base():get_name_id() ) , managers.statistics:session_total_kills() )
		
	end

end )

function PlayerStandard:getUnitRotation( unit )

	if not unit or not alive( unit ) then return 360 end
	
	local unit_position = unit:position()
	local vector = self._camera_unit:position() - unit_position
	local forward = self._camera_unit:rotation():y()
	local rotation = math.floor( vector:to_polar_with_reference( forward , math.UP ).spin )
	
	return -( rotation + 180 )

end