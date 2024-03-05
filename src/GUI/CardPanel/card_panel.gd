extends Panel

var CardType = Card.CardType
@onready var label_title := $LabelTitle
@onready var label_description := $LabelDescription

func set_text(text, desc) -> void:
	label_title.text = text
	label_description.text = desc

func _on_mouse_entered() -> void:
	print("Mouse Entered: %s" % label_title.text)

func _on_mouse_exited() -> void:
	print("Mouse Exited: %s" % label_title.text)
