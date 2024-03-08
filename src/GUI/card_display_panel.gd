extends PanelContainer

@onready var vbox = $CardScroll/CardVBox

var card := preload("res://src/GUI/CardPanel/card_panel.tscn")
var targets_node: Node2D
var game: Game
var current_hand: Array[Card]
var current_id: int = 0
var hand_size: int = 0



func _ready() -> void:
	game = get_parent().get_node("VBoxContainer/SubViewportContainer/SubViewport/Game")
	targets_node = get_parent().get_node("VBoxContainer/SubViewportContainer/SubViewport/Game/Map/MovementTargets")
	PlayerCards.hand_updated.connect(_on_hand_updated)
	_on_hand_updated()
	pass

func _on_hand_updated() -> void:
	current_hand = PlayerCards.hand
	hand_size = current_hand.size()
	update_panel()

func update_panel() -> void:
	for i in vbox.get_children():
		i.queue_free()
	
	for id in range(current_hand.size()):
		var new_card = card.instantiate()
		vbox.add_child(new_card)
		new_card.clicked.connect(target.bind(id))
		new_card.set_text(current_hand[id].name, current_hand[id].description)
		new_card.id = id

func target(params: Array, id: int = 0):
	current_id = id
	if params.size() < 3:
		movement_target(params[0], params[1])
	else:
		movement_target(params[0], params[1], params[2])

func movement_target(axis: Vector2, infinite: bool, axis2: Vector2 = Vector2.ZERO) -> void:
	var targets = []
	var pos = game.player.grid_position
	generate_rotations(axis, targets)
	if axis2 != Vector2.ZERO:
		generate_rotations(axis2, targets)
	place_targets(targets, pos, infinite)
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

func place_targets(target_array: Array, position: Vector2i, infinite: bool, iteration : int = 0) -> void:
	var map_data: MapData = game.player.map_data
	var target = preload("res://src/GUI/MovementTarget/movement_target_instance.tscn")
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
			target_instance.clicked.connect(_on_MovementTargets_clicked)
			if map_data.get_actor_at_location(position + Vector2i(t)):
				continue
			if infinite and iteration < 10:
				place_targets([t], position + Vector2i(t), true, iteration + 1)
			
	pass
	# variables to adjust offsets for overlap when hand > 5
	#var window_size: Vector2 = DisplayServer.window_get_size()
	#var v_margins = 30
	#var card_gap = (window_size.y - v_margins) / hand_size

func _on_MovementTargets_clicked(chosen_vector: Vector2, iteration: int) -> void:
	var current_card : Card = PlayerCards.hand[current_id]
	#PlayerCards.discard_card(current_card.type)
	
	
	#PlayerCards.hand.remove_at(current_id)
	#PlayerCards.discard.append(current_card)	# < - uncomment to turn on discard
	#update_panel()
	
	
	for child in targets_node.get_children():
		child.queue_free()
	var action: Action
	action = BumpAction.new(game.player, chosen_vector.x * iteration, chosen_vector.y * iteration)
	action.perform()
	if action.get_target_actor():
		action = BumpAction.new(game.player, chosen_vector.x * (iteration - 1), chosen_vector.y * (iteration - 1))
		action.perform()
	for item in action.get_map_data().get_items():
		if game.player.grid_position == item.grid_position:
			action = PickupAction.new(game.player)
			action.perform()
	game._handle_enemy_turns()
	game.map.update_fov(game.player.grid_position)
