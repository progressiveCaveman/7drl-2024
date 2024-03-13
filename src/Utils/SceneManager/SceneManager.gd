extends Node

@onready var scene_display := $SceneDisplay
@onready var scene_cache := $SceneCache
@onready var fade_out := $FadeRect
@onready var animation_player := $AnimationPlayer

var current_scene
var previous_scene
var saved = []

var scenes = {
	"title_screen" : preload("res://src/title_screen/title_screen.tscn").instantiate(),
	"game_screen" : preload("res://src/Game/game.tscn").instantiate(),
	"promo_screen" : preload("res://src/Game/game.tscn").instantiate(),
}

func start() -> void:
	current_scene = scenes["title_screen"]
	scene_display.add_child(current_scene)

func change_scene(id: String) -> void:
	current_scene = scene_display.get_child(0)
	animation_player.play("Fade")
	await animation_player.animation_finished
	scene_display.remove_child(current_scene)
	previous_scene = current_scene
	scene_cache.add_child(current_scene)
	current_scene = scenes[id]
	scene_display.add_child(current_scene)
	animation_player.play_backwards("Fade")

