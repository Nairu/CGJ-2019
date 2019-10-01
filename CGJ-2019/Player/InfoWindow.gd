extends Panel

func _ready() -> void:
	Events.connect("prompt_feature", self, "_on_toggle_prompt")

func _on_toggle_prompt(name : String, show : bool) -> void:
	self.visible = show
	$Label.text = name