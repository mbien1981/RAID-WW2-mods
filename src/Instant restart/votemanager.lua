-- Remove the initial 5 second counter
Hooks:PostHook(VoteManager, "_restart_counter", "remove_restart_cooldown", function(self, callback_type)
	self._callback_counter = 0
end)

-- remove the additional 3 second period after checking that all players have spawned
Hooks:PostHook(VoteManager, "update", "remove_restart_delay", function(self, t, dt, paused)
	if self._restart_t then
		self._restart_t = Application:time()
	end
end)
