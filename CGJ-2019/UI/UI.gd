extends Control

onready var health_bar = $HUD/Panel/FullHealth
onready var full_width = $HUD/Panel/DamagedHealth.rect_size.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_health(health_percentage):
	health_bar.rect_size.x = full_width * health_percentage