class_name Game
extends Node2D

signal player_created(player)
signal map_created(map)

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 16

@onready var player: Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D
@onready var targets_node: Node2D = $Map/MovementTargets
@onready var player_depth: int = 1

func _ready() -> void:
	player = Entity.new(null, Vector2i.ZERO, player_definition)
	player_created.emit(player)
	
	remove_child(camera)
	player.add_child(camera)
	
	map.generate(player, player_depth)
	map.update_fov(player.grid_position)
	map_created.emit(map)
	
	MessageLog.send_message.bind(
		"The ORC TAVERN has erupted into violence once again!",
		GameColors.WELCOME_TEXT
	).call_deferred()
	MovementController.game = self
	MovementController.targets_node = targets_node
	camera.make_current.call_deferred()
	SignalBus.end_turn.connect(new_turn)
	SignalBus.use_stairs_down.connect(_use_stairs_down)
	#SignalBus.use_stairs_up.connect(_use_stairs_up)

func _use_stairs_down():
	if map.map_data.get_tile(player.grid_position)._definition.type == TileDefinition.TileType.StairsDown:
		player_depth += 1
		PlayerCards.add_to_store()
		map.generate(player, player_depth)
		map.update_fov(player.grid_position)
		map_created.emit(map)	

#func _use_stairs_up():
	#if player_depth > 1 and map.map_data.get_tile(player.grid_position)._definition.type == TileDefinition.TileType.StairsDown:
		#player_depth -= 1
		#map.generate(player, player_depth)
		#map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	if PlayerCards.actions <= 0:
		new_turn()
	
	var action: Action = await input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		if action.perform():
			new_turn()

func new_turn():
	print("new turn")
	_handle_enemy_turns()
	PlayerCards.draw_to_five()
	PlayerCards.actions = 1
	map.update_fov(player.grid_position)
	

func _handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity.ai_component != null and entity != player:
			entity.ai_component.perform()


func get_map_data() -> MapData:
	return map.map_data
