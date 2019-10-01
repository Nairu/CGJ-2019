extends Area2D


func _ready() -> void:
	Events.connect("prompt_feature", self, "_on_toggle_prompt")
	
	$Timer.connect("timeout", self, "_on_timer_end")

func _on_toggle_prompt(name : String, show : bool, use_timer : bool) -> void:
	
	if use_timer:
		$Timer.one_shot = true
		$Timer.start(3)
	
	$CanvasLayer/Panel.visible = show
	$CanvasLayer/Panel/Label.text = name
	
func _on_timer_end() -> void:
	_on_toggle_prompt("", false, false)