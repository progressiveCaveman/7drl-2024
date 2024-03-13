extends Control

@onready var start_button := $PanelContainer/VBoxContainer/Buttons/VBoxContainer/StartButton
@onready var options_button := $PanelContainer/VBoxContainer/Buttons/VBoxContainer/OptionsButton
@onready var credits_button := $PanelContainer/VBoxContainer/Buttons/VBoxContainer/CreditsButton

func _ready():
	start_button.pressed.connect(_on_Button.bind(1))
	options_button.pressed.connect(_on_Button.bind(2))
	credits_button.pressed.connect(_on_Button.bind(3))

func _on_Button(mode: int):
	match mode:
		1:
			SceneManager.change_scene("game_screen")
		2:
			pass
		3:
			pass
