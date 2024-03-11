extends Node

var mobile_platforms = ["Web", "Android", "iOS"]

func _ready():
	var game_size = Vector2i(ProjectSettings.get_setting('display/window/size/viewport_width'), ProjectSettings.get_setting('display/window/size/viewport_height'))
	var screen_res = DisplayServer.screen_get_size()
	print("game: %s, screen: %s" % [game_size, screen_res])
	
	if game_size > screen_res and OS.get_name() not in mobile_platforms:
		DisplayServer.window_set_size(screen_res/1.1)
		DisplayServer.window_set_position(screen_res - Vector2i(screen_res/1.05))
