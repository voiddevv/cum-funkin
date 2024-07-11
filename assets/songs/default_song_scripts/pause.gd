extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
var paused:bool = false
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		event = event as InputEventKey
		if event.is_pressed():
			if event.keycode == KEY_ENTER:
				var tree = get_tree()
				tree.paused = !tree.paused

				paused = !paused
				
