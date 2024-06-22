class_name BpmChangeEvent extends Event
var bpm:float = 100.0
func _init(_time:float,_bpm:float):
	self.event_name = "BpmChangeEvent"
	self.time = _time
	self.bpm = _bpm
