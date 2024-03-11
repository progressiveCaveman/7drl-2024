extends PanelContainer

@onready var music_option = $VBoxContainer/MusicOption
@onready var sfx_option = $VBoxContainer/SFXOption

func _on_music_changed(value) -> void:
	AudioManager.change_volume(value, 1)
	pass

func _on_music_muted() -> void:
	AudioManager.mute(1)
	pass

func _on_sfx_changed(value) -> void:
	AudioManager.change_volume(value, 2)
	pass

func _on_sfx_muted() -> void:
	AudioManager.mute(2)
	pass
