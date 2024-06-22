extends Node2D
var update_thread:Thread = Thread.new()

signal beat_hit(beat:int)
signal step_hit(step:int)
var audio:AudioStreamPlayer = null
# bpm change balls
var bpm_changes:Array[BpmChangeEvent] = []

var time:float = 0.0
# beat shit
var bpm:float = 100.0
var beat_crochet:float:
	get:
		return 60.0/bpm
var step_crochet:float:
	get:
		return 15.0/bpm
var beat:float = 0.0
var step:float = 0.0

var beati:int:
	get:
		return floor(beat)
var stepi:int:
	get:
		return floor(step)
var _last_time:float = 0.0


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if audio:
		if abs(audio.get_playback_position() - Conductor.time) > 0.015:
			Conductor.time = audio.get_playback_position()
func update():
	var delta = (Time.get_ticks_usec()*0.000001) - _last_time
	time += delta
	beat = time/beat_crochet
	step = time/step_crochet
	if floor(beat) != floor((time + delta)/beat_crochet):
		beat_hit.emit(floori(step + (delta/beat_crochet)))
	if floor(step) != floor((time + delta)/step_crochet):
		step_hit.emit(floori(step + (delta/step_crochet)))
	_last_time += delta
