Hooks:PostHook( HUDStageEndScreen , "set_speed_up" , "uHUDPostHUDStageEndScreenSetSpeedUp" , function( self , multiplier )

	self._loop_speed = true
	self._speed_up = 99

end )

Hooks:PostHook( HUDStageEndScreen , "update" , "uHUDPostHUDStageEndScreenUpdate" , function( self , t , dt )

	if self._loop_speed then self._speed_up = 99 end

end )