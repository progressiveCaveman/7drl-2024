extends TextureRect

signal clicked(vector)

var vector: Vector2
var iteration: int

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			emit_signal("clicked", vector, iteration)
	pass # Replace with function body.