function CarryData:_create_workspace()

	self._gui = World:newgui()
	self._ws = self._gui:create_world_workspace( 100 , 100 , self._unit:position() + Vector3( -25 , 0 , 70 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	self._ws:set_billboard( self._ws.BILLBOARD_BOTH )
	
	self._ws_t = self._ws:panel():text({
		name 		= "carry_data",
		text 		= string.lower( tweak_data.carry[ self._carry_id ].name_id and managers.localization:text( tweak_data.carry[ self._carry_id ].name_id ) ):gsub( "(%l)(%w*)" , function( a , b ) return string.upper( a ) .. b end ),
		y 			= 0,
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 30,
		align 		= "center",
		vertical 	= "center",
		layer 		= 1,
		visible 	= uHUD:HasSetting( "carry" ) and true or false,
		color 		= uHUD:HasSetting( "carry_colour" ) and Color( uHUD:HasSetting( "carry_colour" ) ) or Color.white
	})
	
	local ux , uy , uw , uh = self._ws_t:text_rect()
	self._ws_t:set_w( uw )
	
	if self._ws:panel():w() < self._ws_t:w() then
		self._ws_t:animate( callback( self , self , "_animate_text" ) , self._ws_t:w() - self._ws:panel():w() )
	end

end

function CarryData:_destroy_workspace()

	if self._gui and alive( self._gui ) and self._ws and alive( self._ws ) then
		self._ws_t:stop()
		self._gui:destroy_workspace( self._ws )
		self._gui = nil
		self._ws = nil
	end

end

function CarryData:_animate_text( text , width )

	local t = 0
	
	while true do
		
		t = t + coroutine.yield()
		text:set_center_x( width * ( math.sin( 90 + t * 100 ) * 0.5 - 0.5 ) )
		
	end

end

Hooks:PostHook( CarryData , "init" , "uHUDPostCarryDataInit" , function( self , unit )

	if not self._ws and self._carry_id then
		self:_create_workspace()
	end

end )

Hooks:PreHook( CarryData , "update" , "uHUDPreCarryDataUpdate" , function( self , unit , t , dt )

	if not self._ws then
		if self._unit and self._unit:interaction()._active and self._carry_id then
			self:_create_workspace()
		end
		return
	end
	
	if self._unit:interaction()._active then
		self._ws:set_world( 100 , 100 , self._unit:position() + Vector3( -25 , 0 , 70 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	else
		self:_destroy_workspace()
	end

end )

Hooks:PostHook( CarryData , "destroy" , "uHUDPostCarryDataDestroy" , function( self )

	self:_destroy_workspace()

end )