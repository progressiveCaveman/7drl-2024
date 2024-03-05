class_name CardAction
extends Action

var card: Card
var target_position: Vector2i


func _init(entity: Entity, card: Card, target_position = null) -> void:
	super._init(entity)
	self.card = card
	if not target_position is Vector2i:
		target_position = entity.grid_position
	self.target_position = target_position


func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(target_position)


func perform() -> bool:
	if card == null:
		return false
	
	if PlayerCards.play_card(card.type):
		#match card.type:
			print("asd")

	print("playing card. This does nothing")
	return true #item.consumable_component.activate(self)
