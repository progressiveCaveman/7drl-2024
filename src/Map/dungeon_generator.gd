class_name DungeonGenerator
extends Node

const entity_types = {
	"orc": preload("res://assets/definitions/entities/actors/entity_definition_orc.tres"),
	"rat": preload("res://assets/definitions/entities/actors/entity_definition_rat.tres"),
	"troll": preload("res://assets/definitions/entities/actors/entity_definition_troll.tres"),
	"health_potion": preload("res://assets/definitions/entities/items/health_potion_definition.tres"),
	"lightning_scroll": preload("res://assets/definitions/entities/items/lightning_scroll_definition.tres"),
	"confusion_scroll": preload("res://assets/definitions/entities/items/confusion_scroll_definition.tres"),
	"fireball_scroll": preload("res://assets/definitions/entities/items/fireball_scroll_definition.tres"),
	"gold_stack": preload("res://assets/definitions/entities/items/gold_stack_definition.tres")
}

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

@export_category("Entities RNG")
@export var max_monsters_per_room: int = 2
@export var max_items_per_room: int = 2

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func generate_dungeon(player:Entity) -> MapData:
	var dungeon := MapData.new(map_width, map_height, player)
	dungeon.entities.append(player)
	
	var rooms: Array[Rect2i] = []
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		#_carve_room(dungeon, new_room)
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
			player.map_data = dungeon
		else:
			_tunnel_drunkard(dungeon, rooms.back().get_center(), new_room.get_center())
		
		rooms.append(new_room)
	
	_bomb_level(dungeon)
	
	for room in rooms:
		_place_entities(dungeon, room)
	
	dungeon.setup_pathfinding()
	return dungeon


func _carve_room(dungeon: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(dungeon, x, y)

func _bomb_level(dungeon: MapData) -> void:
	# create an array of all open tiles
	var candidates: Array[Vector2i] = []
	
	for x in range(1, map_width - 1):
		for y in range(1, map_height - 1):
			var tile_position = Vector2i(x, y)
			var tile: Tile = dungeon.get_tile(tile_position)
			if tile.is_walkable():
				candidates.append(tile_position)
	
	candidates.shuffle()
	
	var dungeon_openness_modifier = 1.8
	var iteration_amt = candidates.size() * dungeon_openness_modifier
	
	for i in range(0, iteration_amt):
		if candidates.size() <= 1:
			print("Bail out on iteration %s " % i)
			break
		
		var idx_offset = 0
		
		# 1/3 chance that bombing point will be in last 15 positions
		if randi() % 3  == 0:
			idx_offset = max(0, candidates.size() - 15 + randi() % 15)
		else: # otherwise use lower half of candidates
			idx_offset = randi() % (candidates.size() / 2)
			
		# check idx_offset bounds
		idx_offset = min(idx_offset, candidates.size() - 1)
		
		var idx = candidates[idx_offset]
		var bomb_radius = 1 # can give a chance of larger bombs here for variation
		
		# max(0, tx - bomb_radius - 1) Is -1 important here??
		for x in range(max(1, idx.x - bomb_radius), min(map_width - 1, idx.x + bomb_radius)):
			for y in range(max(1, idx.y - bomb_radius), min(map_width - 1, idx.y + bomb_radius)):
				# check if tile is within circle (Ranges select a square)
				if (x - idx.x) * (x - idx.x) + (y - idx.y) * (y - idx.y) < bomb_radius * bomb_radius + bomb_radius:
					
					# bail out if out of bounds. Is this necessary?
					if x >= map_width || y >= map_height || x <= 0 || y <= 0:
						continue
					
					# bomb out coords and add new open spaces to candidates
					var tile_position = Vector2i(x, y)
					var tile: Tile = dungeon.get_tile(tile_position)
					if not tile.is_walkable():
						_carve_tile(dungeon, x, y)
						candidates.append(tile_position)
			
		candidates.erase(idx)

func _tunnel_horizontal(dungeon: MapData, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(dungeon, x, y)


func _tunnel_vertical(dungeon: MapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(dungeon, x, y)


func _tunnel_between(dungeon: MapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start.x, end.x)
		_tunnel_vertical(dungeon, end.x, start.y, end.y)
	else:
		_tunnel_vertical(dungeon, start.x, start.y, end.y)
		_tunnel_horizontal(dungeon, end.y, start.x, end.x)

func _tunnel_drunkard(dungeon: MapData, start: Vector2i, end: Vector2i) -> void:
	var x = start.x
	var y = start.y
	_carve_tile(dungeon, x, y)
	
	while x != end.x || y != end.y:
		var xdir = -1 if start.x > end.x else 1
		var ydir = -1 if start.y > end.y else 1
		
		var xdiff = abs(x - end.x)
		var ydiff = abs(y - end.y)
		
		if ydiff > 3 * xdiff:
			y += ydir
		elif xdiff > 3 * ydiff:
			x += xdir
		else:
			if randi() % 2 == 0:
				x += xdir
			else:
				y += ydir
				
		_carve_tile(dungeon, x, y)

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)


enum RoomSpawnType {
	Orcs,
	Rats,
	TrollAndOrc
}

func _place_entities(dungeon: MapData, room: Rect2i) -> void:
	var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	var number_of_items: int = _rng.randi_range(0, max_items_per_room)
	var roomtype: RoomSpawnType = _rng.randi_range(0, 3)
	
	var monsters_placed = 0
	while monsters_placed < number_of_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place = dungeon.get_tile(new_entity_position).is_walkable()
		for entity in dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			monsters_placed += 1
			var new_entity: Entity
			var item_1: Entity
			var item_2: Entity
			var item_3: Entity
			match roomtype:
				RoomSpawnType.Orcs:
					new_entity = Entity.new(dungeon, new_entity_position, entity_types.orc)
					item_1 = Entity.new(dungeon, new_entity_position, entity_types.gold_stack)
					item_1.consumable_component.set_amount(_rng.randi_range(1, 2))
					new_entity.inventory_component.items.append(item_1)
				RoomSpawnType.Rats:
					new_entity = Entity.new(dungeon, new_entity_position, entity_types.rat)
					item_1 = Entity.new(dungeon, new_entity_position, entity_types.gold_stack)
					item_1.consumable_component.set_amount(1)
					new_entity.inventory_component.items.append(item_1)
				RoomSpawnType.TrollAndOrc:
					if _rng.randf() < 0.8:
						new_entity = Entity.new(dungeon, new_entity_position, entity_types.orc)
						item_1 = Entity.new(dungeon, new_entity_position, entity_types.gold_stack)
						item_1.consumable_component.set_amount(_rng.randi_range(1, 3))
						new_entity.inventory_component.items.append(item_1)
					else:
						new_entity = Entity.new(dungeon, new_entity_position, entity_types.troll)
						item_1 = Entity.new(dungeon, new_entity_position, entity_types.gold_stack)
						item_1.consumable_component.set_amount(_rng.randi_range(2, 4))
						new_entity.inventory_component.items.append(item_1)
						
				_:
					continue
			
			dungeon.entities.append(new_entity)
	
	var items_placed = 0	
	while items_placed < number_of_items:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place = dungeon.get_tile(new_entity_position).is_walkable()
		for entity in dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			items_placed += 1
			var item_chance: float = _rng.randf()
			var new_entity: Entity
			if item_chance < 0.7:
				new_entity = Entity.new(dungeon, new_entity_position, entity_types.health_potion)
			elif item_chance < 0.8:
				new_entity = Entity.new(dungeon, new_entity_position, entity_types.fireball_scroll)
			elif item_chance < 0.9:
				new_entity = Entity.new(dungeon, new_entity_position, entity_types.confusion_scroll)
			else:
				new_entity = Entity.new(dungeon, new_entity_position, entity_types.lightning_scroll)
			dungeon.entities.append(new_entity)
