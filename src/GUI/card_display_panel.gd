extends PanelContainer

@onready var vbox = $CardScroll/CardVBox

var card := preload("res://src/GUI/CardPanel/card_panel.tscn")
var targets_node: Node2D
var game: Game
var current_hand: Array[Card]
var hand_size: int = 0



func _ready() -> void:
	game = get_parent().get_node("VBoxContainer/SubViewportContainer/SubViewport/Game")
	targets_node = get_parent().get_node("VBoxContainer/SubViewportContainer/SubViewport/Game/Map/MovementTargets")
	PlayerCards.hand_updated.connect(_on_hand_updated)
	_on_hand_updated()
	pass

func _on_hand_updated() -> void:
	current_hand.clear()
	current_hand = PlayerCards.hand
	hand_size = current_hand.size()
	update_panel()

func update_panel() -> void:
	for i in vbox.get_children():
		i.queue_free()
	
	for id in range(current_hand.size()):
		var new_card = card.instantiate()
		vbox.add_child(new_card)
		new_card.clicked.connect(target)
		new_card.set_text(current_hand[id].name, current_hand[id].description)

func target(params: Array):
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
			return
		else:
		#if position + t not wall:
			var target_instance = target.instantiate()
			target_instance.vector = t
			targets_node.add_child(target_instance)
			target_instance.position = Grid.grid_to_world(position + Vector2i(t) )
			target_instance.clicked.connect(_on_MovementTargets_clicked)
			if infinite and iteration < 10:
				place_targets([t], position + Vector2i(t), true, iteration + 1)
			
	pass
	# variables to adjust offsets for overlap when hand > 5
	#var window_size: Vector2 = DisplayServer.window_get_size()
	#var v_margins = 30
	#var card_gap = (window_size.y - v_margins) / hand_size

func _on_MovementTargets_clicked(chosen_vector: Vector2) -> void:
	for child in targets_node.get_children():
		child.queue_free()
	pass
