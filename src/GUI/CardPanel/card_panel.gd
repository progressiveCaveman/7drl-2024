extends Panel

var CardType = Card.CardType
@onready var label_title := $VBoxContainer/LabelTitle
@onready var label_description := $VBoxContainer/LabelDescription


var normal_stylebox: StyleBoxTexture = get_theme_stylebox("panel")
var new_stylebox: StyleBoxTexture = get_theme_stylebox("panel").duplicate()

var id : int = 0
var value : int = 0

var type = "debug"

signal clicked(params: Array)
signal bought()

var movement_params = {
	"Pawn" : [Vector2( 1, 1), false],
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
	else:
		type = "mod"
		label_title.modulate = Color.INDIAN_RED
		new_stylebox.modulate_color = Color.INDIAN_RED

func set_value(_value: int) -> void:
	value = _value
	type = "shop"

func _on_mouse_entered() -> void:
	add_theme_stylebox_override('panel', new_stylebox)
	print("Mouse Entered: %s" % label_title.text)
	

func _on_mouse_exited() -> void:
	add_theme_stylebox_override('panel', normal_stylebox)
	print("Mouse Exited: %s" % label_title.text)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			if type != "shop":
				# left click
				var card = PlayerCards.title_to_type(label_title.text)
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
					_:
						print("unhandled enum")
						return
				PlayerCards.play_card(card)
			else:
				emit_signal("bought", value)
		elif event.button_index == 2:
			# right click
			pass
