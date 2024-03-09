class_name GoldConsumableComponent
extends ConsumableComponent

var amount: int


func _init(definition: GoldConsumableComponentDefinition) -> void:
	amount = definition.gold_amount

func set_amount(new_amount: int):
	amount = new_amount

func activate(action: ItemAction) -> bool:
	var consumer: Entity = action.entity
	var amount_recieved: int = consumer.inventory_component.recieve_gold(amount)
	if amount_recieved > 0:
		MessageLog.send_message(
			"You gain %s gold!" % amount_recieved,
			GameColors.HEALTH_RECOVERED
		)
		consume(consumer)
		return true
	return false
