class_name Player extends Node2D
@export var notefield:NoteField
@export var does_input:bool = true
@export var autoplay:bool = false
signal notehit(note:Note)
signal notemiss(note:Note)
var notemiss_callback:Callable = note_miss
var notehit_callback:Callable = note_hit
var stats:PlayerStats = PlayerStats.new()
var pressed:Array[bool] = []
var keycount:int = 4
var note_actions:PackedStringArray = ["note_left","note_down","note_up","note_right"]
var id:int = -1
var chars:Array[Character] = []
## ffmpreg
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.use_accumulated_input = false
	pressed.resize(keycount)
	pressed.fill(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for note:Note in notefield.notes.get_children():
		if autoplay:
			if note.time < Conductor.time and not note.was_hit:
				note.was_hit = true
				notehit_callback.call(note)
				notehit.emit(note)
				note.sustain_ticking = true
		## dumb ass miss code :3
		if Conductor.time - (note.time + note.og_sustain_length) > 0.180 and not note.missed:
			note.missed = true
			note.sprite.modulate = Color.DIM_GRAY
			notemiss_callback.call(note)
			notemiss.emit(note)
		if note.was_hit and not note.missed:
			
			note.sprite.visible = false
			if not pressed[note.column]:
				if not note.missed:
					if note.sustain_length <= Conductor.step_crochet:
						if not autoplay:
							note.missed = true
							notemiss_callback.call(note)
							notemiss.emit(note)
							return
			note.sustain_length -= delta
			if note.sustain_ticking:
				note.sustain_tick_timer -= delta
			if note.sustain_length < 0:
				note.queue_free()
			if note.sustain_tick_timer <= 0.0:
				notehit_callback.call(note)
				notehit.emit(note)

			
	pass
func ev_to_dir(ev:InputEvent) -> int:
	var i = 0
	for act in note_actions:
		if ev.is_action(note_actions[i]):
			return i
		i += 1
	return -1

func _unhandled_input(event):
	var dir:int = ev_to_dir(event)
	if dir == -1 or event.is_echo() or !does_input:
		return
	pressed[dir] = event.is_pressed()
	## note shit do later
	
	var strum = notefield.strums.get_child(dir)
	if event.is_pressed():
		if notefield:
			var hit_notes = notefield.notes.get_children()
			hit_notes = hit_notes.filter(func(n:Note): if n.can_hit and not n.too_late and not n.missed and not n.was_hit and n.column == dir: return n)
			if not hit_notes.is_empty():
				hit_notes.front().was_hit = true
				notehit_callback.call(hit_notes.front())
				hit_notes.front().sustain_ticking = true
		if not strum.animation.contains("confirm"): 
			notefield.strums.get_child(dir).play_anim(Strum.PRESSED)
	else:
		notefield.strums.get_child(dir).play_anim(Strum.STATIC)
func note_miss(note:Note):
	stats.combo_breaks += 1
	for i in chars:
		i.sing(note.column)
	print("missed a note")
	pass
	
func note_hit(note:Note):
	if not note.sustain_ticking:
		stats.score += 350
			
	if not note.sustain_ticking:
		if note.og_sustain_length > 0.0:
			note.og_sustain_length -= (Conductor.time - note.time)
			note.sustain_length = note.og_sustain_length
			
	note.sustain_tick_timer = Conductor.step_crochet
	
	var strum:Strum = note.notefield.strums.get_child(note.column)
	strum.play_anim(Strum.CONFIRM,true)
	if not strum.animation_finished.is_connected(strum.play_anim.bind(0)) and autoplay:
		strum.animation_finished.connect(strum.play_anim.bind(0),CONNECT_ONE_SHOT)
		
	for i in chars:
		i.sing(note.column)
		
func rating_shit(hit_time:float):
	pass
