class_name Note extends Node2D
## nodes ##
@onready var sprite:AnimatedSprite2D = $sprite
@onready var sustain = $sustain
var notefield:NoteField = null
## backend ##
var cumlumn:int:
	get:
		return column
var time:float

var column:int

var og_sustain_length:float

var sustain_length:float

var sustain_ticking:bool = false

var sustain_tick_timer:float = INF

var scroll_speed:float
var can_hit:bool:
	get:
		return absf((time) - Conductor.time) <= 0.180
var too_late:bool:
	get:
		return (Conductor.time - (self.time + og_sustain_length)) > 0.240
var missed:bool = false
var was_hit:bool = false
