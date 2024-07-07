extends Node2D

@onready var icon = $Icon
@onready var logo: AnimatedSprite2D = $logo
@onready var check_box: CheckBox = $CheckBox

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	check_box.set_pressed_no_signal(Game.shaders)
	Conductor.beat_hit.connect(beat)
	Conductor.reset()
	

func _process(delta):
	Conductor.time += delta
	
func beat(b):
	logo.play("logo bumpin")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		get_tree().change_scene_to_file("res://game/menus/main_menu.tscn")
		


func _on_check_box_toggled(toggled_on: bool) -> void:
	Game.shaders = toggled_on
	pass # Replace with function body.
