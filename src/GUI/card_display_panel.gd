extends PanelContainer

@onready var vbox = $CardVBox

var card := preload("res://src/GUI/CardPanel/card_panel.tscn")
var player_cards: Cards
var current_hand: Array[Cards.Card]
var hand_size: int = 0

func _ready() -> void:
	var game = get_parent().get_node("VBoxContainer/SubViewportContainer/SubViewport/Game")
	await game.hand_initialized == true
	player_cards = game.player_cards
	game.player_cards.hand_updated.connect(_on_hand_updated)
	_on_hand_updated()
	pass

func _on_hand_updated() -> void:
	current_hand.clear()
	current_hand = player_cards.hand
	hand_size = current_hand.size()
	update_panel()

func update_panel() -> void:
	for i in vbox.get_children():
		i.queue_free()
	
	for id in range(current_hand.size()):
		var new_card = card.instantiate()
		vbox.add_child(new_card)
		new_card.set_text(current_hand[id].name)
	
	# variables to adjust offsets for overlap when hand > 5
	#var window_size: Vector2 = DisplayServer.window_get_size()
	#var v_margins = 30
	#var card_gap = (window_size.y - v_margins) / hand_size
