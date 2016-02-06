Hooks:PostHook( HUDMissionBriefing , "set_slot_ready" , "uHUDPostHUDMissionBriefingSetSlotReady" , function( self , peer , peer_id )

	local slot = self._ready_slot_panel:child( "slot_" .. tostring( peer_id ) )
	
	if not slot or not alive( slot ) then
		return
	end
	
	slot:child( "status" ):set_color( Color.green )

end )

Hooks:PostHook( HUDMissionBriefing , "set_slot_not_ready" , "uHUDPostHUDMissionBriefingSetSlotNotReady" , function( self , peer , peer_id )

	local slot = self._ready_slot_panel:child( "slot_" .. tostring( peer_id ) )
	
	if not slot or not alive( slot ) then
		return
	end
	
	slot:child( "status" ):set_color( Color.red )

end )