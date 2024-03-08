extends Panel

var CardType = Card.CardType
@onready var label_title := $VBoxContainer/LabelTitle
@onready var label_description := $VBoxContainer/LabelDescription


var normal_stylebox: StyleBoxTexture = get_theme_stylebox("panel")
var new_stylebox: StyleBoxTexture = get_theme_stylebox("panel").duplicate()

var id = 0

var type = "debug"

signal clicked(params: Array)

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

func _on_mouse_entered() -> void:
	add_theme_stylebox_override('panel', new_stylebox)
	print("Mouse Entered: %s" % label_title.text)
	

func _on_mouse_exited() -> void:
	add_theme_stylebox_override('panel', normal_stylebox)
	print("Mouse Exited: %s" % label_title.text)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			# left click
			if type == "move":
				emit_signal('clicked', movement_params[label_title.text])
			pass
		elif event.button_index == 2:
			# right click
			pass

func movement_target(axis: Vector2, infinite: bool, axis2: Vector2 = Vector2.ZERO) -> void:
	pass

func generate_rotations(axis: Vector2, target_array: Array) -> void:
	pass

func place_targets(target_array: Array, position:) -> void:
	pass
