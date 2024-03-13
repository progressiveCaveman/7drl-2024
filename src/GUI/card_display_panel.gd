extends PanelContainer

@onready var vbox = $CardScroll/CardVBox
@onready var market_vbox = $MarketScroll/VBoxContainer
@onready var hflow = $MarketScroll/VBoxContainer/HFlowContainer

var card := preload("res://src/GUI/CardPanel/card_panel.tscn")
var targets_node: Node2D
var previews_node: Node2D
var game: Game
var current_hand: Array[Card]
var current_id: int = 0
var hand_size: int = 0
var trasher = false
var trasher_id = null

enum modes {
	CURRENT_HAND,
	MARKET_DISPLAY
}

@export var current_mode = modes.CURRENT_HAND

func _ready() -> void:
	SignalBus.num_event.connect(_on_num_event)
	SignalBus.trasher_activated.connect(_on_trasher)
	SignalBus.trashed.connect(_on_trashed)
	game = get_parent().get_node("SubViewportContainer/SubViewport/Game")
	targets_node = get_parent().get_node("SubViewportContainer/SubViewport/Game/Map/MovementTargets")
	MovementController.targets_node = targets_node
	previews_node = get_parent().get_node("SubViewportContainer/SubViewport/Game/Map/TargetPreviews")
	MovementController.previews_node = previews_node
	PlayerCards.hand_updated.connect(_on_hand_updated)
	#for i in range(20):
		#var new_card = Card.new(Card.CardType.King)
		#new_card.set_cost(randi_range(10, 50))
		#PlayerCards.add_to_store(new_card)
	_on_hand_updated()
	pass

func _on_trasher(id):
	var children =  vbox.get_children()
	for i in children.size():
		if i != id:
			children[i].modulate = Color.RED
			children[i].trash = true
	trasher_id = id

func _on_trashed(id):
	MessageLog.send_message("%s has been removed from play." % PlayerCards.hand[id].name, GameColors.ENEMY_DIE)
	PlayerCards.hand.remove_at(id)
	PlayerCards.play_card(
		PlayerCards.hand[trasher_id].type
	)
	pass

func _on_num_event(num):
	if num > vbox.get_child_count():
		return
	var _card = vbox.get_child(num - 1)
	var new_card = PlayerCards.title_to_type(_card.label_title.text)
	_card.card_match(new_card)
	PlayerCards.play_card(new_card)

func _on_hand_updated() -> void:
	current_hand = PlayerCards.hand
	hand_size = current_hand.size()
	update_panel()

func toggle_mode() -> int:
	if current_mode == modes.CURRENT_HAND:
		current_mode = modes.MARKET_DISPLAY
		update_panel()
		
		return 1
	else:
		current_mode = modes.CURRENT_HAND
		update_panel()
		return 0

func update_panel() -> void:
	for i in vbox.get_children():
		i.queue_free()
	for ii in hflow.get_children():
		ii.queue_free()
	
	if current_mode == modes.CURRENT_HAND:
		market_vbox.visible = false
		vbox.visible = true
		size_flags_stretch_ratio = 1.0
		for id in range(current_hand.size()):
			var new_card = card.instantiate()
			new_card.map_data = game.get_map_data()
			new_card.player = game.player
			vbox.add_child(new_card)
			new_card.clicked.connect(target.bind(id))
			new_card.focus_change.connect(preview.bind(id))
			new_card.set_text(current_hand[id].name, current_hand[id].description)
			new_card.id = id
	elif current_mode == modes.MARKET_DISPLAY:
		market_vbox.visible = true
		vbox.visible = false
		var store_array = PlayerCards.available_to_buy
		size_flags_stretch_ratio = 5.0
		for id in range(store_array.size()):
			var new_card = card.instantiate()
			var value_label = Label.new()
			var vbox = VBoxContainer.new()
			vbox.add_child(new_card)
			vbox.add_child(value_label)
			vbox.custom_minimum_size = Vector2(0, 240)
			vbox.alignment = BoxContainer.ALIGNMENT_CENTER
			hflow.add_child(vbox)
			new_card.bought.connect(purchase.bind(id))
			new_card.set_text(store_array[id].name, store_array[id].description)
			new_card.set_value(store_array[id].cost)#store_array[id].value)
			value_label.text = str(store_array[id].cost)
			value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			var new_settings = LabelSettings.new()
			new_settings.font_color = GameColors.INVALID
			new_settings.font = preload("res://assets/fonts/kenney_kenney-fonts/Fonts/Kenney Pixel Square.ttf")
			new_settings.font_size = 16
			value_label.label_settings = new_settings
			new_card.id = id
		pass

func target(params: Array, id: int = 0):
	MovementController.clear_targets()
	if trasher:
		trasher = false
		PlayerCards.discard_card(Card.CardType.Trasher)
		PlayerCards.hand.erase(PlayerCards.hand[id])
		PlayerCards.hand_updated.emit()
		update_panel()
	else:
		if id != 0:
			MovementController.current_id = id
		if params.size() < 3:
			MovementController.movement_target(game.player, params[0], params[1])
		else:
			MovementController.movement_target(game.player, params[0], params[1], params[2])
		update_panel()

func preview(params: Array, on: bool, id: int = 0):
	MovementController.clear_targets(1)
	if on:
		if params.size() < 3:
			MovementController.movement_target_preview(game.player, params[0], params[1])
		else:
			MovementController.movement_target_preview(game.player, params[0], params[1], params[2])
	pass

func purchase(value, id) -> void:
	var card = PlayerCards.available_to_buy[id]
	if card.cost <= game.player.inventory_component.gold:
		PlayerCards.gain_card(card.type)
		game.player.inventory_component.spend_gold(card.cost)
		MessageLog.send_message("Bought %s for %s gold." % [card.name, card.cost], GameColors.INVALID)
		#PlayerCards.available_to_buy.remove_at(id)
	else:
		MessageLog.send_message("You can't afford this card.", GameColors.INVALID)
	update_panel()

#func movement_target(axis: Vector2, infinite: bool, axis2: Vector2 = Vector2.ZERO) -> void:
	#var targets = []
	#var pos = game.player.grid_position
	#generate_rotations(axis, targets)
	#if axis2 != Vector2.ZERO:
		#generate_rotations(axis2, targets)
	#place_targets(targets, pos, infinite)
	#pass
#
#func generate_rotations(axis: Vector2, target_array: Array) -> void:
	#var _x = axis.x
	#var _y = axis.y
	#target_array.append(Vector2(_x, _y))
	#target_array.append(Vector2(_x, -_y))
	#target_array.append(Vector2(-_x, _y))
	#target_array.append(Vector2(-_x, -_y))
	## Annoying second section just for the knight
	#if Vector2(_y, _x) not in target_array:
		#target_array.append( Vector2(_y, _x) )
	#if Vector2(_y, -_x) not in target_array:
		#target_array.append( Vector2(_y, -_x) )
	#if Vector2(-_y, _x) not in target_array:
		#target_array.append( Vector2(-_y, _x) )
	#if Vector2(-_y, -_x) not in target_array:
		#target_array.append( Vector2(-_y, -_x) )
#
#func place_targets(target_array: Array, position: Vector2i, infinite: bool, iteration : int = 0) -> void:
	#var map_data: MapData = game.player.map_data
	#var target = preload("res://src/GUI/MovementTarget/movement_target_instance.tscn")
	#for t in target_array:
		#var destination_tile: Tile = map_data.get_tile(position + Vector2i(t))
		#if not destination_tile.is_walkable() or destination_tile.visible == false:
			#continue
		#else:
		##if position + t not wall:
			#var target_instance = target.instantiate()
			#target_instance.vector = t
			#target_instance.iteration = iteration + 1
			#targets_node.add_child(target_instance)
			#target_instance.position = Grid.grid_to_world(position + Vector2i(t) )
			#target_instance.clicked.connect(_on_MovementTargets_clicked)
			#if map_data.get_actor_at_location(position + Vector2i(t)):
				#continue
			#if infinite and iteration < 10:
				#place_targets([t], position + Vector2i(t), true, iteration + 1)
			#
	#pass
	## variables to adjust offsets for overlap when hand > 5
	##var window_size: Vector2 = DisplayServer.window_get_size()
	##var v_margins = 30
	##var card_gap = (window_size.y - v_margins) / hand_size
#
#func _on_MovementTargets_clicked(chosen_vector: Vector2, iteration: int) -> void:
	#var current_card : Card = PlayerCards.hand[current_id]
	##PlayerCards.discard_card(current_card.type)
	#
	#
	##PlayerCards.hand.remove_at(current_id)
	##PlayerCards.discard.append(current_card)	# < - uncomment to turn on discard
	##update_panel()
	#
	#
	#for child in targets_node.get_children():
		#child.queue_free()
	#var action: Action
	#action = BumpAction.new(game.player, chosen_vector.x * iteration, chosen_vector.y * iteration)
	#action.perform()
	#if action.get_target_actor():
		#action = BumpAction.new(game.player, chosen_vector.x * (iteration - 1), chosen_vector.y * (iteration - 1))
		#action.perform()
	#for item in action.get_map_data().get_items():
		#if game.player.grid_position == item.grid_position:
			#action = PickupAction.new(game.player)
			#action.perform()
	#game._handle_enemy_turns()
	#game.map.update_fov(game.player.grid_position)
