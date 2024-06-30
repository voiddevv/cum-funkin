extends Node2D

var fullscreen:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			get_tree().paused = false
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if event is InputEventKey:
			event = event as InputEventKey
			if not fullscreen:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				if event.shift_pressed:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
					
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = not fullscreen
		pass
