extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var start_time = 0.0
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		event = event as InputEventKey
		if event.is_pressed():
			if event.keycode == KEY_ENTER:
				get_tree().paused = not get_tree().paused
				if get_tree().paused:
					start_time = Conductor.stepi
				else:
					print(Conductor.stepi - start_time)
					
