extends Node

var sounds = {
	"Debug" : {
		"blank_breaker_soft" : preload("res://assets/audio/sounds/blank_breaker_soft.wav"),
		"blank_breaker_soft_wiggle" : preload("res://assets/audio/sounds/blank_breaker_soft_wiggle.wav"),
		"blocked_by_wall" : preload("res://assets/audio/sounds/blocked_by_wall.wav"),
		"player_attack3" : preload("res://assets/audio/sounds/player_attack3.wav"),
		"player_attack" : preload("res://assets/audio/sounds/player_attack.wav"),
		"player_dead" : preload("res://assets/audio/sounds/player_dead.wav"),
		"player_heal" : preload("res://assets/audio/sounds/player_heal.wav"),
		"player_hurt" : preload("res://assets/audio/sounds/player_hurt.wav"),
		"player_pickup" : preload("res://assets/audio/sounds/player_pickup.wav"),
		"player_pickup_potion" : preload("res://assets/audio/sounds/player_pickup_potion.wav"),
		"player_pickup_scroll" : preload("res://assets/audio/sounds/player_pickup_scroll.wav"),
		"player_pickup_scroll_2" : preload("res://assets/audio/sounds/player_pickup_scroll_2.wav"),
		"player_recieve_gold" : preload("res://assets/audio/sounds/player_recieve_gold.wav"),
		"player_spend_gold" : preload("res://assets/audio/sounds/player_spend_gold.wav"),
		"player_step" : preload("res://assets/audio/sounds/player_step.wav"),
		"player_use_potion" : preload("res://assets/audio/sounds/player_use_potion.wav"),
		"player_use_scroll" : preload("res://assets/audio/sounds/player_use_scroll.wav"),
	},
	"Player" : {},
	"Enemy" : {},
	"Game" : {},
}

@onready var music_player : AudioStreamPlayer2D = $MusicPlayer
@onready var sound_player : AudioStreamPlayer2D = $SoundPlayer


func play_sound(sound_library: String, sound_title: String, pitch_variation: float = 0.0) -> void:
	var new_sound = sounds[sound_library][sound_title]
	sound_player.stream = new_sound
	if pitch_variation != 0.0:
		var pitch_mod = 1.0 + randf_range(-pitch_variation, pitch_variation)
		sound_player.pitch_scale = pitch_mod
	elif sound_player.pitch_scale != 1.0:
		sound_player.pitch_scale = 1.0
	sound_player.play()
