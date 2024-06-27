class_name BpmChangeEvent extends Event
var bpm:float = 100.0
var step:float = 0.0
func get_event_name():
	return "BpmChange"
func _init(_time:float = 0.0,_bpm:float = 100.0,_step:float = 0.0):
	self.time = _time
	self.bpm = _bpm
	self.step = _step
