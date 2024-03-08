extends Node

var game: Game = null
var targets_node: Node2D = null
var target_node_array: Array
var current_id: int = 0


var target = preload("res://src/GUI/MovementTarget/movement_target_instance.tscn")

func movement_target(actor: Entity, axis: Vector2, infinite: bool, axis2: Vector2 = Vector2.ZERO) -> void:
	var targets = []
	var pos = actor.grid_position
	generate_rotations(axis, targets)
	if axis2 != Vector2.ZERO:
		generate_rotations(axis2, targets)
	place_targets(actor, targets, pos, infinite)
	if actor.entity_name != "Player":
		var targ = choose_target(actor, targets)
		_on_MovementTargets_clicked(targ.vector, targ.iteration, actor)
	pass

func generate_rotations(axis: Vector2, target_array: Array) -> void:
	var _x = axis.x
	var _y = axis.y
	target_array.append(Vector2(_x, _y))
	target_array.append(Vector2(_x, -_y))
	target_array.append(Vector2(-_x, _y))
	target_array.append(Vector2(-_x, -_y))
	# Annoying second section just for the knight
	if Vector2(_y, _x) not in target_array:
		target_array.append( Vector2(_y, _x) )
	if Vector2(_y, -_x) not in target_array:
		target_array.append( Vector2(_y, -_x) )
	if Vector2(-_y, _x) not in target_array:
		target_array.append( Vector2(-_y, _x) )
	if Vector2(-_y, -_x) not in target_array:
		target_array.append( Vector2(-_y, -_x) )

func place_targets(actor: Entity, target_array: Array, position: Vector2i, infinite: bool, iteration : int = 0) -> void:
	var map_data: MapData = actor.map_data
	target_node_array = []
	for t in target_array:
		var destination_tile: Tile = map_data.get_tile(position + Vector2i(t))
		if not destination_tile.is_walkable() or destination_tile.visible == false:
			continue
		else:
		#if position + t not wall:
			var target_instance = target.instantiate()
			target_instance.vector = t
			target_instance.iteration = iteration + 1
			targets_node.add_child(target_instance)
			target_instance.position = Grid.grid_to_world(position + Vector2i(t) )
			target_instance.clicked.connect(_on_MovementTargets_clicked.bind(actor))
			target_node_array.append(target_instance)
			if map_data.get_actor_at_location(position + Vector2i(t)):
				continue
			if infinite and iteration < 10:
				place_targets(actor, [t], position + Vector2i(t), true, iteration + 1)
			
	pass
	# variables to adjust offsets for overlap when hand > 5
	#var window_size: Vector2 = DisplayServer.window_get_size()
	#var v_margins = 30
	#var card_gap = (window_size.y - v_margins) / hand_size

func choose_target(actor: Entity, target_array: Array):
	var closest = Vector2i(9999, 9999)
	var current_target
	var target = game.player.grid_position
	for t in targets_node.get_children():
		if abs((actor.grid_position + (Vector2i(t.vector) * t.iteration)) - target) < closest:
			closest = ((actor.grid_position + (Vector2i(t.vector) * t.iteration)) - target)
			current_target = t
	return current_target

func _on_MovementTargets_clicked(chosen_vector: Vector2, iteration: int, actor: Entity) -> void:
	var current_card : Card = PlayerCards.hand[current_id]
	#PlayerCards.discard_card(current_card.type)
	
	
	#PlayerCards.hand.remove_at(current_id)
	#PlayerCards.discard.append(current_card)	# < - uncomment to turn on discard
	#update_panel()
	
	
	for child in targets_node.get_children():
		child.queue_free()
	var action: Action
	action = BumpAction.new(actor, chosen_vector.x * iteration, chosen_vector.y * iteration)
	action.perform()
	if action.get_target_actor():
		action = BumpAction.new(actor, chosen_vector.x * (iteration - 1), chosen_vector.y * (iteration - 1))
		action.perform()
	for item in action.get_map_data().get_items():
		if game.player.grid_position == item.grid_position and actor.type != actor.AIType.HOSTILE:
			action = PickupAction.new(game.player)
			action.perform()
	if actor.entity_name == "Player":
		game._handle_enemy_turns()
		game.map.update_fov(game.player.grid_position)
