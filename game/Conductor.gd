extends Node2D
var update_thread:Thread = Thread.new()

signal beat_hit(beat:int)
signal step_hit(step:int)
var audio:AudioStreamPlayer = null
# bpm change balls
var bpm_changes:Array[BpmChangeEvent] = []:
	set(v):
		bpm_changes = v
		print("changed bpm map")

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
var _last_change:BpmChangeEvent = null

func queue_bpm_change(change_event:BpmChangeEvent):
	if not bpm_changes.has(change_event):
		bpm_changes.append(change_event)
		bpm_changes.sort_custom(func(a,b): a.time < b.time)

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in bpm_changes:
		if time > i.time and _last_change != i:
			_last_change = i
			bpm = i.bpm
			continue
	if audio:
		if abs(audio.get_playback_position() - Conductor.time) > 0.015:
			Conductor.time = audio.get_playback_position()
func update():
	var delta = (Time.get_ticks_usec()*0.000001) - _last_time
	time += delta
	var last_step = step
	var last_beat = beat
	## fall back shit ig
	if bpm_changes.size() < 1:
		_last_change = BpmChangeEvent.new(0.0,bpm,0.0)
	beat = _last_change.step/4.0 + ((time - _last_change.time)/beat_crochet)
	step = _last_change.step + ((time - _last_change.time)/step_crochet)
	if floori(step) != floori(last_step):
		var step_diff:int = step - last_step
		for i in range(step,step + step_diff+1):
			step_hit.emit(floor(i))
	if floori(beat) != floori(last_beat):
		var beat_diff:int = beat - last_beat
		for i in range(beat,beat + beat_diff+1):
			beat_hit.emit(floori(i))
	_last_time += delta
func reset():
	bpm_changes.clear()
	time = 0.0
	bpm = 100.0
	update()
