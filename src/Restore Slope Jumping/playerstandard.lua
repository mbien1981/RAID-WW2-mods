Hooks:OverrideFunction(PlayerStandard, "_check_action_jump", function(self, t, input)
	local new_action = nil

	if not input.btn_jump_press then
		return new_action
	end

	-- local angle_limit = tweak_data.player.max_floor_jump_angle[self._not_moving_t > 0.1 and "max" or "min"]
	local action_forbidden = self._jump_t and t < self._jump_t + 0.55
	-- action_forbidden = action_forbidden or self._gnd_angle and angle_limit < self._gnd_angle
	action_forbidden = action_forbidden
		or self._unit:base():stats_screen_visible()
		or self:in_air()
		or self:_interacting()
		or self:_on_zipline()
		or self:_does_deploying_limit_movement()
		or self:_is_using_bipod()
		or self:_is_comm_wheel_active()
		or self:_mantling()

	if not action_forbidden then
		if self._state_data.ducking then
			self:_interupt_action_ducking(t)
		elseif not self:_check_action_mantle(t, input) then
			if self._state_data.on_ladder then
				self:_interupt_action_ladder(t)
			end

			local action_start_data = {}
			local jump_vel_z = self._tweak_data.movement.jump_velocity.z
			jump_vel_z = jump_vel_z * managers.player:temporary_upgrade_value("temporary", "candy_jump_boost", 1)
			action_start_data.jump_vel_z = jump_vel_z

			if self._move_dir then
				local is_running = self._running and t - self._start_running_t > 0.2
				local jump_vel_xy = self._tweak_data.movement.jump_velocity.xy[is_running and "run" or "walk"]
				action_start_data.jump_vel_xy = jump_vel_xy

				if is_running then
					self._unit:movement():subtract_stamina(self._unit:movement():get_jump_stamina_drain())
				end
			end

			new_action = self:_start_action_jump(t, action_start_data)
		end
	end

	return new_action
end)
