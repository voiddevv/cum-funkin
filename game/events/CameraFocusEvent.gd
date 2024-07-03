class_name CameraFocusEvent extends Event
func get_event_name():
	return "CameraFocus"
var target:int = -1
func _init(_time:float,_target:int) -> void:
	self.time = _time
	self.target = _target

func fire():
	if Game.instance:
		var game = Game.instance
		var character:Character = game.player_list[target].chars.front()
		if Game.instance.stage.camera:
			if character.camera_position:
				game.stage.camera.position = character.camera_position.global_position
