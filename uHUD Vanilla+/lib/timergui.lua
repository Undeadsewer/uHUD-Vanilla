function TimerGui:_create_workspace()

	local obj = self._unit:get_object( Idstring( self._gui_object or "gui_name" ) )

	self._ut_gui = World:newgui()
	self._utws = self._ut_gui:create_object_workspace( 100 , 100 , obj , Vector3( 0 , -200 , -50 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	self._utws:set_billboard( self._utws.BILLBOARD_BOTH )
	
	self._ut = self._utws:panel():text({
		name 		= "timer",
		text 		= string.format( ( "%02d:%02d" ) , math.floor( self._timer / 60 ) , math.floor( self._timer % 60 ) ),
		--text 		= "30:00",
		y 			= 0,
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 60,
		align 		= "center",
		vertical 	= "center",
		layer 		= 1,
		visible 	= uHUD:HasSetting( "timers" ) and true or false,
		color 		= Color.white
	})

end

Hooks:PostHook( TimerGui , "_start" , "uHUDPostTimerGuiStart" , function( self , timer , current_timer )

	--[[if not self._unit then return end
	
	if not TimerGui._timer_labels then TimerGui._timer_labels = {} end
	
	local last_id = TimerGui._timer_labels and TimerGui._timer_labels[ #TimerGui._timer_labels ] or 0
	self._tid = last_id + 1
	
	table.insert( TimerGui._timer_labels , self._tid )
	
	managers.hud:add_timer_label( self._unit:get_object( Idstring( "gui_name" ) ) , self._tid , self._unit:interaction().tweak_data , self._timer , self._time_left )]]
	
	if not self._ut then self:_create_workspace() end

end )

Hooks:PostHook( TimerGui , "update" , "uHUDPostTimerGuiUpdate" , function( self , unit , t , dt )

	if not self._ut then self:_create_workspace() end
	if not self._time_left then return end
	
	if not uHUD:HasSetting( "timers" ) then
		self._ut:set_visible( false )
		return
	end
	
	self._ut:set_color( self._jammed and ( uHUD:HasSetting( "timers_jammed_colour" ) and Color( uHUD:HasSetting( "timers_jammed_colour" ) ) or Color.red ) or ( uHUD:HasSetting( "timers_colour" ) and Color( uHUD:HasSetting( "timers_colour" ) ) or Color.white ) )
	self._ut:set_text( string.format( ( "%.0f:" .. ( math.floor( self._time_left % 60 ) < 10 and "0" or "" ) .. "%.0f" ) , math.floor( self._time_left / 60 ) , math.floor( self._time_left % 60 ) ) )
	--self._ut:set_text( "30:00" )

end )

Hooks:PostHook( TimerGui , "done" , "uHUDPostTimerGuiDone" , function( self )

	if self._ut_gui and alive( self._ut_gui ) and self._utws and alive( self._utws ) then
		self._ut_gui:destroy_workspace( self._utws )
		self._utws = nil
		self._ut_gui = nil
	end

end )

Hooks:PostHook( TimerGui , "destroy" , "uHUDPostTimerGuiDestroy" , function( self )

	if self._ut_gui and alive( self._ut_gui ) and self._utws and alive( self._utws ) then
		self._ut_gui:destroy_workspace( self._utws )
		self._utws = nil
		self._ut_gui = nil
	end

end )