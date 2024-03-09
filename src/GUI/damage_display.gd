extends MarginContainer

@onready var damage_label: Label = $"%DamageLabel"

func initialize(player: Entity) -> void:
	await ready
	PlayerCards.damage_changed.connect(update)
	update(PlayerCards.actions)

func update(damage: int) -> void:
	damage_label.text = "Damage Modifier: %d" % damage
