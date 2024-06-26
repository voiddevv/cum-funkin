class_name NoteField extends Node2D
var note_data:Array[NoteData] = []:
	set(v):
		note_data = v
		note_data = note_data.filter(func(a): if a.player == self.player.id: return a)
		note_data.sort_custom(func(a,b): return a.time < b.time)
var notes:Node2D = Node2D.new()
@export var player:Player = null
@onready var strums:Node2D = Node2D.new()
const temp_note = preload("res://game/notes/normal.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if SaveMan.get_data("downscroll",false):
		position.y = 720 - position.y
#region gen_strums
	add_child(strums)
	add_child(notes)
	for i in player.keycount:
		var strum:Strum = Strum.new()
		strum.column = i
		strum.sprite_frames = preload("res://assets/NOTE_assets.res")
		strum.position.x += (-2 + i)*110.0
		strum.position.x += 110.0/2.0
		strum.scale = Vector2.ONE*0.7
		strum.play_anim(Strum.STATIC)
		strums.add_child(strum)
#endregion

var note_index:int = 0
func queue_notes():
	var last_data:NoteData
	for i in note_data:
		if last_data:
			if i.column == last_data.column and abs(i.time - last_data.time) <= 0.005:
				#print("stack note found")
				note_data.erase(last_data)
		last_data = i
		
	for i in range(note_index,note_data.size()):
		var data = note_data[i]
		var scrollspeed = Game.chart.scroll_speed if SaveMan.get_data("scroll_speed",1.0) == 1.0 else SaveMan.get_data("scroll_speed",1.0)
		var down_scroll_mult = 1.0 if not SaveMan.get_data("downscroll",false) else -1.0
		if data.time > Conductor.time + (2.2/(scrollspeed/Conductor.rate)):
			break
		
		var note = temp_note.instantiate()
		note.column = data.column
		note.time = data.time
		note.sustain_length = max(data.length - Conductor.step_crochet,0.0)
		note.og_sustain_length = max(data.length - Conductor.step_crochet,0.0)
		note.scroll_speed = scrollspeed
		note.notefield = self
		notes.add_child(note)
		note.sprite.play(Strum.column_to_str(note.column))
		note.global_position.x = strums.get_child(note.column).global_position.x
		note.sustain.points[1].y = ((450*note.sustain_length)*(note.scroll_speed/Conductor.rate)*down_scroll_mult)/note.scale.y
		note.tail.position = note.sustain.get_point_position(1) + Vector2(0,32)*down_scroll_mult
		if down_scroll_mult == -1:
			note.tail.flip_v = true
		note_index += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_notes()
	var down_scroll_mult = 1.0 if not SaveMan.get_data("downscroll",false) else -1.0
	
	for note:Note in notes.get_children():
		var strum = strums.get_child(note.column)
		if note.too_late:
			note.queue_free()
		note.global_position.y = strum.global_position.y - (450 * (Conductor.time - note.time)) * (note.scroll_speed/Conductor.rate) * down_scroll_mult
		if note.was_hit:
			note.global_position = strum.global_position
			note.sustain.points[1].y = ((450*note.sustain_length)*(note.scroll_speed/Conductor.rate)*down_scroll_mult)/note.scale.y
			note.tail.position = note.sustain.get_point_position(1) + Vector2(0,32)*down_scroll_mult
			
