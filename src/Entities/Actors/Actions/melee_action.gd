class_name MeleeAction
extends ActionWithDirection


func perform() -> bool:
	var target: Entity = get_target_actor()
	if not target:
		if entity == get_map_data().player:
			MessageLog.send_message("Nothing to attack.", GameColors.IMPOSSIBLE)
		return false
	
	var damage: int = entity.fighter_component.power - target.fighter_component.defense
	if entity == get_map_data().player:
		damage += PlayerCards.damage_mod
		PlayerCards.damage_mod = 0
	
	var attack_color: Color
	if entity == get_map_data().player:
		attack_color = GameColors.PLAYER_ATTACK
	else:
		attack_color = GameColors.ENEMY_ATTACK
	var attack_description: String = "%s attacks %s" % [entity.get_entity_name(), target.get_entity_name()]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		MessageLog.send_message(attack_description, attack_color)
		target.fighter_component.hp -= damage
		AudioManager.play_sound('Debug', 'player_attack', 0.2)
	else:
		attack_description += " but does no damage."
		MessageLog.send_message(attack_description, attack_color)
		AudioManager.play_sound('Debug', 'player_pickup_scroll_2', 0.2)
	return true
