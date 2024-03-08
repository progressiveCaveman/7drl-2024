extends Panel

var CardType = Card.CardType
@onready var label_title := $VBoxContainer/LabelTitle
@onready var label_description := $VBoxContainer/LabelDescription
var id = 0

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

#func _on_mouse_entered() -> void:
	#print("Mouse Entered: %s" % label_title.text)
	#
#
#func _on_mouse_exited() -> void:
	#print("Mouse Exited: %s" % label_title.text)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			# left click
			var cardt = PlayerCards.title_to_type(label_title.text)
			match cardt:
				Card.CardType.Pawn:
					emit_signal('clicked', movement_params[label_title.text])
				Card.CardType.Rook:
					emit_signal('clicked', movement_params[label_title.text])
					PlayerCards.draw_card()
				Card.CardType.Damage1:
					PlayerCards.damage_mod += 1
				Card.CardType.Knight:
					emit_signal('clicked', movement_params[label_title.text])
					PlayerCards.actions += 1
				Card.CardType.Queen:
					emit_signal('clicked', movement_params[label_title.text])
					PlayerCards.actions += 2
					PlayerCards.draw_card()
				Card.CardType.King:
					emit_signal('clicked', movement_params[label_title.text])
					PlayerCards.actions += 1
					PlayerCards.draw_card()
					PlayerCards.draw_card()
					PlayerCards.draw_card()
				Card.CardType.Damage2:
					PlayerCards.damage_mod += 2
				_:
					print("unhandled enum")
					return
			PlayerCards.play_card(cardt)
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
