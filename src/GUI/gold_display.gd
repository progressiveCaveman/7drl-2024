extends MarginContainer

@onready var gold_label: Label = $"%GoldLabel"


func initialize(player: Entity) -> void:
	await ready
	player.inventory_component.gold_updated.connect(gold_changed)
	gold_changed(0)


func gold_changed(gold: int) -> void:
	gold_label.text = "Player Gold: %d" % [gold]
