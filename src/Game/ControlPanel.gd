extends PanelContainer

@onready var end_turn_button = $VBoxContainer/HBoxContainer/EndTurnButton
@onready var options_button = $VBoxContainer/HBoxContainer/VBoxContainer/OptionsButton
@onready var card_market_button = $VBoxContainer/HBoxContainer/VBoxContainer/CardMarketButton

@onready var card_display_panel
@onready var messages_panel
@onready var options_panel

func _ready() -> void:
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	options_button.pressed.connect(_on_options_pressed)
	card_market_button.pressed.connect(_on_card_market_pressed)
	card_display_panel = get_parent().get_parent().get_node('VBoxContainer/CardDisplayPanel')
	messages_panel = get_parent().get_parent().get_node('InfoBar/MessagesPanel')
	options_panel = get_parent().get_parent().get_node('InfoBar/OptionsPanel')
	PlayerCards.store_updated.connect(_on_store_updated)
	#card_market_button.disabled = true

func _on_end_turn_pressed() -> void:
	print("end turn")

func _on_options_pressed() -> void:
	#Input.action_press("activate")
	if messages_panel.visible == true:
		messages_panel.visible = false
		options_panel.visible = true
	else:
		messages_panel.visible = true
		options_panel.visible = false
		
	

func _on_card_market_pressed() -> void:
	var mode = card_display_panel.toggle_mode()
	if mode == 0:
		card_market_button.text = "CARD MARKET"
	else:
		card_market_button.text = "RETURN"
	#card_display_panel
	print("card market")

func _on_store_updated():
	if PlayerCards.available_to_buy.size() > 0:
		card_market_button.disabled = false
	else:
		card_market_button.disabled = true
