extends TextureRect

signal clicked(vector)

var vector: Vector2
var iteration: int
var active: bool = true

func _ready():
	var new_texture = AtlasTexture.new()
	new_texture.atlas = texture.atlas
	if !active:
		modulate = Color(0.58, 0.878, 0.537, 0.71)
		new_texture.region = Rect2(16, 0, 16, 16)
	
	if active:
		modulate = Color(0.58, 0.878, 0.537, 0.71)
		new_texture.region = Rect2(0, 0, 16, 16)
	texture = new_texture

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse"):
			if active:
				emit_signal("clicked", vector, iteration)
			else:
				MessageLog.send_message("You must play the card to move", GameColors.IMPOSSIBLE)
	pass # Replace with function body.
