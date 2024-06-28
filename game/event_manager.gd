extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var cur_event:int = 0

signal event_fired(ev:Event)

func _process(delta: float) -> void:
	for i in range(cur_event,Game.chart.meta.events.size()):
		var ev = Game.chart.meta.events[i]
		if Conductor.time >= ev.time:
			cur_event += 1
			event_fired.emit(ev)
			ev.fire()
func fire_event(ev:Event):
	ev.fire()
func queue_event(ev:Event):
	Game.chart.meta.events.append(ev)
	Game.chart.meta.events.sort_custom(func(a,b): a.time < b.time)
