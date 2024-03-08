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
		match card.type:
			Card.CardType.Error:
				return false
			Card.CardType.Pawn:
				return true
			Card.CardType.Rook:
				return true
			Card.CardType.Damage1:
				PlayerCards.damage_mod += 1
				return true
			Card.CardType.Knight:
				return true
			Card.CardType.Queen:
				return true
			Card.CardType.King:
				return true
			Card.CardType.Damage2:
				PlayerCards.damage_mod += 2
				return true

	print("failed to play card")
	return false 
