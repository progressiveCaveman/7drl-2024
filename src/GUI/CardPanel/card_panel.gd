extends Panel

var CardType = Card.CardType
@onready var label_title := $VBoxContainer/LabelTitle
@onready var label_description := $VBoxContainer/LabelDescription
var trash = false


var normal_stylebox: StyleBoxTexture = get_theme_stylebox("panel")
var new_stylebox: StyleBoxTexture = get_theme_stylebox("panel").duplicate()

var id : int = 0
var value : int = 0

var type = "debug"

signal focus_change(params: Array, on: bool)
signal clicked(params: Array)
signal bought(value: int)

var movement_params = {
	"Pawn" : [Vector2( 0, 1), false],
	"Bishop" : [Vector2( 1, 1), true],
	"Rook" : [Vector2( 1, 0), true],
	"Knight" : [Vector2( 2, 1), false],
	"Queen" : [Vector2( 1, 1), true, Vector2(1, 0)],
	"King" : [Vector2( 1, 1), false, Vector2(1, 0)],
	"Error" : [Vector2( 0, 0), false],
}

func set_text(text: String, desc: String) -> void:
	label_title.text = text
	label_description.text = desc
	if label_title.text in movement_params:
		type = "move"
		label_title.modulate = Color.AQUAMARINE
		new_stylebox.modulate_color = Color.AQUAMARINE
	elif label_title.text == "Trasher":
		type = "trasher"
	else:
		type = "mod"
		label_title.modulate = Color.INDIAN_RED
		new_stylebox.modulate_color = Color.INDIAN_RED
	
	if label_description.text.length() > 50:
		var _new_settings = label_description.label_settings.duplicate()
		_new_settings.font_size -= 4
		label_description.label_settings = _new_settings


func set_value(_value: int) -> void:
	value = _value
	type = "shop"

func _on_mouse_entered() -> void:
	add_theme_stylebox_override('panel', new_stylebox)
	if type == "move":
		#MovementController.clear_targets()
		emit_signal('focus_change', movement_params[label_title.text], true)
	#else:
		#MovementController.clear_targets()
	

func _on_mouse_exited() -> void:
	if type == "move":
		emit_signal('focus_change', movement_params[label_title.text], false)
	add_theme_stylebox_override('panel', normal_stylebox)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse"):
		if type != "shop":
			# left click
			if type == "trasher":
				SignalBus.trasher_activated.emit(id)
			elif trash == true:
				SignalBus.trashed.emit(id)
			else:
				var card = PlayerCards.title_to_type(label_title.text)
				card_match(card)
				
				PlayerCards.play_card(card)
		else:
			emit_signal("bought", value)

func card_match(card):
	match card:
		Card.CardType.Pawn:
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.Rook:
			PlayerCards.draw_card()
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.Damage1:
			PlayerCards.damage_mod += 1
		Card.CardType.Knight:
			PlayerCards.actions += 2
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.Queen:
			PlayerCards.actions += 2
			PlayerCards.draw_card()
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.King:
			PlayerCards.actions += 1
			PlayerCards.draw_card()
			PlayerCards.draw_card()
			PlayerCards.draw_card()
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.Damage2:
			PlayerCards.damage_mod += 2
		Card.CardType.Bishop:
			PlayerCards.damage_mod += 2
			emit_signal('clicked', movement_params[label_title.text])
		Card.CardType.Trasher:
			SignalBus.trasher_activated.emit()
			print("trash not implemented")
		Card.CardType.Village:
			PlayerCards.actions += 2
			PlayerCards.draw_card()
		Card.CardType.Laboratory:
			PlayerCards.actions += 1
			PlayerCards.draw_card()
			PlayerCards.draw_card()
		Card.CardType.MagicMissile:
			print("MagicMissile not implemented")
		Card.CardType.Fireball:
			print("Fireball not implemented")
		Card.CardType.Cleave:
			print("Cleave not implemented")
		_:
			print("unhandled enum")
