extends PanelContainer


@onready var end_turn_button = $VBoxContainer/HBoxContainer/EndTurnButton
@onready var inventory_button = $VBoxContainer/HBoxContainer/VBoxContainer/InventoryButton
@onready var card_market_button = $VBoxContainer/HBoxContainer/VBoxContainer/CardMarketButton

@onready var card_display_panel

func _ready() -> void:
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	inventory_button.pressed.connect(_on_inventory_pressed)
	card_market_button.pressed.connect(_on_card_market_pressed)
	card_display_panel = get_parent().get_parent().get_node('VBoxContainer/CardDisplayPanel')
	PlayerCards.store_updated.connect(_on_store_updated)
	card_market_button.disabled = true

func _on_end_turn_pressed() -> void:
	SignalBus.end_turn.emit()

func _on_inventory_pressed() -> void:
	Input.action_press("activate")

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
