extends Node2D

@onready var icon = $Icon
@onready var logo: AnimatedSprite2D = $logo

# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.beat_hit.connect(beat)
	Conductor.reset()
	

func _process(delta):
	Conductor.update()
	
func beat(b):
	logo.play("logo bumpin")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		get_tree().change_scene_to_file("res://gmae.tscn")
		
