class_name Game
extends Node2D

signal player_created(player)

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 16
const starting_deck = [Cards.CardType.Pawn, Cards.CardType.Pawn, Cards.CardType.Pawn, Cards.CardType.Pawn, Cards.CardType.Rook, 
	Cards.CardType.Rook, Cards.CardType.Damage1, Cards.CardType.Damage1, Cards.CardType.Damage1, Cards.CardType.Damage1]

@onready var player: Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D
@onready var player_cards: Cards


func _ready() -> void:
	player = Entity.new(null, Vector2i.ZERO, player_definition)
	player_created.emit(player)
	
	player_cards = Cards.new()
	for c in starting_deck:
		player_cards.gain_card(c)
	player_cards.shuffle_discard()
	print("Player hand:")
	for i in range(0,5):
		player_cards.draw_card()
		print(player_cards.hand[i].name)
	
	remove_child(camera)
	player.add_child(camera)
	
	map.generate(player)
	map.update_fov(player.grid_position)
	
	MessageLog.send_message.bind(
		"Hello and welcome, adventurer, to yet another dungeon!",
		GameColors.WELCOME_TEXT
	).call_deferred()
	
	camera.make_current.call_deferred()

func _physics_process(_delta: float) -> void:
	var action: Action = await input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		if action.perform():
			_handle_enemy_turns()
			map.update_fov(player.grid_position)


func _handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity.ai_component != null and entity != player:
			entity.ai_component.perform()


func get_map_data() -> MapData:
	return map.map_data
