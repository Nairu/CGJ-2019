extends Control

func _on_GoBack_pressed():
	get_tree().change_scene('res://Scenes/TitleScreen.tscn')


func _on_CreditText_meta_clicked(meta):
	OS.shell_open(meta)
