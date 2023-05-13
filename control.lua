script.on_event(defines.events.on_player_changed_position,
    function(event)
        local player = game.get_player(event.player_index) -- get the player that moved
        -- if they're wearing the fire armour
        if player.character and player.get_inventory(defines.inventory.character_armor).get_item_count("fire-armor") >= 1 then
            -- create fire at player's location
            player.surface.create_entity{name="fire-flame", position=player.position, force="neutral"}
        end
    end
)