class_name ItemAction
extends Action

var item: Entity
var target_position: Vector2i


func _init(entity: Entity, item: Entity, target_position = null) -> void:
	super._init(entity)
	self.item = item
	if target_position == null:
		target_position = entity.grid_position
	self.target_position = target_position


func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(target_position)


func perform() -> bool:
	if item == null:
		return false
	return item.consumable_component.activate(self)
