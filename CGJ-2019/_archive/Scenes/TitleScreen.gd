extends Control

func _ready():
	if not $"/root/MusicPlayer".get_child(0).playing:
		$"/root/MusicPlayer".get_child(0).play()

func _on_PlayGame_pressed():
	$"/root/MusicPlayer".get_child(0).stop()
	get_tree().change_scene('res://Scenes/Level1.tscn')


func _on_Credits_pressed():
	get_tree().change_scene('res://Scenes/CreditsScene.tscn')

func _on_Exit_pressed():
	get_tree().quit()

func _on_MusicToggle_toggled(button_pressed):
	AudioServer.set_bus_mute(1, button_pressed)

func _on_SfxToggle_toggled(button_pressed):
	AudioServer.set_bus_mute(2, button_pressed)
