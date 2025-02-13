function NetworkAccountSTEAM:_clbk_inventory_load(error, list)
	self._inventory_is_loading = nil

	list = {}
	local cards = tweak_data.challenge_cards:get_all_cards_indexed()

	for i = 1, #cards, 1 do
		table.insert(list, {
			bonus = false, --Always false
			def_id = cards[i]["def_id"], --Card ID number
			amount = table.random({ 1, 69, 420, 999 }), --It doesn't matter what number this is - will count as 1 by the game anyway
			category = "challenge_card",
			quality = "", --Always nil
			entry = cards[i]["key_name"], --Card name
			instance_id = 0, --A unique ID for each instance of the card.
		})
	end

	local filtered_cards = self:_verify_filter_cards(list)
	local filtered_crafts = self:_verify_filter_crafts(list)

	managers.system_event_listener:call_listeners(
		CoreSystemEventListenerManager.SystemEventListenerManager.EVENT_STEAM_INVENTORY_LOADED,
		{
			error = error,
			cards = filtered_cards,
			crafts = filtered_crafts,
		}
	)
end

function NetworkAccountSTEAM:inventory_remove(instance_id)
	--Nothing!
end
