class_name BpmChangeEvent extends Event
var bpm:float = 100.0
var step:float = 0.0
func _init(_time:float,_bpm:float,_step:float = 0.0):
	self.event_name = "BpmChangeEvent"
	self.time = _time
	self.bpm = _bpm
	self.step = _step
