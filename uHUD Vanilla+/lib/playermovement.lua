Hooks:PostHook( PlayerMovement , "_upd_underdog_skill" , "uHUDPostPlayerMovementUpdUnderdogSkill" , function( self , t )

	if not self._underdog_skill_data.has_dmg_dampener then return end
	
	if not self._attackers or self:downed() then
		managers.hud:hide_underdog()
		return
	end
	
	local my_pos = self._m_pos
	local nr_guys = 0
	local activated
	for u_key, attacker_unit in pairs(self._attackers) do
		if not alive(attacker_unit) then
			self._attackers[u_key] = nil
			managers.hud:hide_underdog()
			return
		end
		local attacker_pos = attacker_unit:movement():m_pos()
		local dis_sq = mvector3.distance_sq(attacker_pos, my_pos)
		if dis_sq < self._underdog_skill_data.max_dis_sq and math.abs(attacker_pos.z - my_pos.z) < 250 then
			nr_guys = nr_guys + 1
			if nr_guys >= self._underdog_skill_data.nr_enemies then
				activated = true
				managers.hud:show_underdog()
			end
		else
		end
	end

end )