class_name InventoryComponent
extends Component

var items: Array[Entity]
var capacity: int
var gold: int = 0

func _init(capacity: int) -> void:
	items = []
	self.capacity = capacity


func drop(item: Entity) -> void:
	items.erase(item)
	var map_data: MapData = get_map_data()
	map_data.entities.append(item)
	map_data.entity_placed.emit(item)
	item.map_data = map_data
	item.grid_position = entity.grid_position
	if entity.entity_name == "Player":
		MessageLog.send_message("You dropped the %s." % item.get_entity_name(), Color.WHITE)
	else:
		MessageLog.send_message("%s dropped %s." % [entity.name, item.get_entity_name()], Color.WHITE)



func recieve_gold(amount: int) -> int:
	gold += amount
	return amount

func spend_gold(amount: int) -> int:
	gold -= amount
	return amount
