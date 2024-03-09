extends MarginContainer

@onready var action_label: Label = $"%ActionLabel"

func initialize(player: Entity) -> void:
	await ready
	PlayerCards.actions_changed.connect(update)
	update(PlayerCards.actions)

func update(actions: int) -> void:
	action_label.text = "Actions: %d" % actions
