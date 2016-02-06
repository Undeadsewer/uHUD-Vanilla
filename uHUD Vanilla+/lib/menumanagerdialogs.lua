Hooks:PostHook( MenuManager , "show_person_joining" , "uHUDPostMenuManagerShowPersonJoining" , function( self , id , nick )

	local dlg = managers.system_menu:get_dialog( "user_dropin" .. id )
	local peer = managers.network:session():peer( id )
	
	if dlg and peer then
	
		local name = nick .. " (" .. peer:level() .. ")"
		
		if peer:rank() > 0 then
			name = nick .. " (" .. peer:rank() .. "-" .. peer:level() .. ")"
		end
		
		dlg:set_title( string.upper( managers.localization:text( "dialog_dropin_title" , { USER = name } ) ) )
	
	end

end )