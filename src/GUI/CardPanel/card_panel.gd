extends Panel

var CardType = Card.CardType
@onready var label := $Label

func set_text(text) -> void:
	label.text = text

func _on_mouse_entered() -> void:
	print("Mouse Entered: %s" % label.text)

func _on_mouse_exited() -> void:
	print("Mouse Exited: %s" % label.text)
