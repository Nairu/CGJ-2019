extends Area2D

var curr_parent : String

onready var timer : Timer = $Timer

func _ready() -> void:
	Events.connect("prompt_feature", self, "_on_toggle_prompt")
	timer.connect("timeout", self, "_on_timer_end")

func _on_toggle_prompt(show : bool, name : String, use_timer : bool, parent : String) -> void:
	if not show and curr_parent != parent:
		pass
	else:
		curr_parent = parent
	
	if use_timer:
		timer.start(1)
	else:
		timer.stop()
	
	$CanvasLayer/Panel.visible = show
	$CanvasLayer/Panel/Label.text = name
	
func _on_timer_end() -> void:
	_on_toggle_prompt(false, "", false, curr_parent)