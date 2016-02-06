function AmmoBagBase:_create_workspace()

	self._gui = World:newgui()
	self._ws = self._gui:create_world_workspace( 100 , 100 , self._unit:position() + Vector3( -25 , 0 , 60 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	self._ws:set_billboard( self._ws.BILLBOARD_BOTH )
	
	self._ws_t = self._ws:panel():text({
		name 		= "amount",
		text 		= string.format( "%d%%" , ( ( self._ammo_amount or 0 ) / ( self._max_ammo_amount or 1 ) ) * 100 ),
		y 			= 0,
		font 		= tweak_data.menu.pd2_large_font,
		font_size 	= 45,
		align 		= "center",
		vertical 	= "center",
		layer 		= 1,
		visible 	= uHUD:HasSetting( "deployable" ) and true or false,
		color 		= uHUD:HasSetting( "deployable_colour" ) and Color( uHUD:HasSetting( "deployable_colour" ) ) or Color.white
	})

end

function AmmoBagBase:_destroy_workspace()

	if self._gui and alive( self._gui ) and self._ws and alive( self._ws ) then
		self._gui:destroy_workspace( self._ws )
		self._gui = nil
		self._ws = nil
	end

end

function AmmoBagBase:_attach()

	if self._is_attachable then
		local from_pos = self._unit:position() + self._unit:rotation():z() * 10
		local to_pos = self._unit:position() + self._unit:rotation():z() * -10
		local ray = self._unit:raycast( "ray" , from_pos , to_pos , "slot_mask" , managers.slot:get_mask( "world_geometry" ) )
		if ray then
			self._attached_data = {}
			self._attached_data.body = ray.body
			self._attached_data.position = ray.body:position()
			self._attached_data.rotation = ray.body:rotation()
			self._attached_data.index = 1
			self._attached_data.max_index = 3
			self._unit:set_extension_update_enabled( Idstring( "base" ) , true )
		end
	end

end

Hooks:PostHook( AmmoBagBase , "_set_visual_stage" , "uHUDPostAmmoBagBaseSetVisualStage" , function( self )

	if self._empty then return end
	
	if not self._ws then
		self:_attach()
		self:_create_workspace()
	end

end )

Hooks:PreHook( AmmoBagBase , "update" , "uHUDPreAmmoBagBaseUpdate" , function( self , unit , t , dt )

	if self._empty then self:_destroy_workspace() return end
	if not self._ws then self:_create_workspace() end
	
	self._ws:set_world( 100 , 100 , self._unit:position() + Vector3( -25 , 0 , 60 ) , Vector3( 50 , 0 , 0 ) , Vector3( 0 , 0 , -50 ) )
	self._ws_t:set_text( string.format( "%d%%" , ( ( self._ammo_amount or 0 ) / ( self._max_ammo_amount or 1 ) ) * 100 ) )

end )

Hooks:PostHook( AmmoBagBase , "destroy" , "uHUDPostAmmorBagBaseDestroy" , function( self )

	self:_destroy_workspace()

end )