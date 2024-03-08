extends MarginContainer

@onready var action_label: Label = $"%ActionLabel"

func initialize(player: Entity) -> void:
	await ready
	PlayerCards.actions_changed.connect(update.bind(0))
	update(PlayerCards.actions)


func update(actions: int) -> void:
	print("asewwe")
	action_label.text = "Actions: %d" % actions
