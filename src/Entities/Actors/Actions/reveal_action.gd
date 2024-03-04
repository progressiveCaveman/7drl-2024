class_name RevealAction
extends Action


func perform() -> bool:	
	var map_data: MapData = get_map_data()
	map_data.reveal_map()
	return true
	
