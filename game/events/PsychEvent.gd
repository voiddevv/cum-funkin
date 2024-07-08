class_name PsychEvent extends Event

var one: String
var two: String
var name: StringName

func get_event_name():
	return name

func _init(time: float, one: String, two: String) -> void:
	self.time = time
	self.one = one
	self.two = two
