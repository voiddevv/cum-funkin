class_name NoteField extends Node2D
var note_data:Array[NoteData] = []:
	set(v):
		note_data = v
		note_data = note_data.filter(func(a): if a.player%Game.meta.players.size() == self.player.id: return a)
		note_data.sort_custom(func(a,b): return a.time < b.time)
var notes:Node2D = Node2D.new()
@export var player:Player = null
var strums:Node2D
var temp_note = load("res://game/notes/normal.tscn")
var strumline:PackedScene = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if SaveMan.get_data("downscroll",false):
		position.y = 720 - position.y
#region gen_strums
	
	add_child(strums)
	add_child(notes)
	## stinky eww
	#for i in 4:
		#var strum:Strum = Strum.new()
		#strum.column = i
		#strum.sprite_frames = preload("res://assets/NOTE_assets.res")
		#strum.position.x += (-2 + i)*110.0
		#strum.position.x += 110.0/2.0
		#strum.scale = Vector2.ONE*0.7
		#strum.play_anim(Strum.STATIC)
		#strums.add_child(strum)
#endregion

var note_index:int = 0
func queue_notes():
		
	for i in range(note_index,note_data.size()):
		var data = note_data[i]
		var scrollspeed = Game.chart.scroll_speed if SaveMan.get_data("scroll_speed",1.0) == 1.0 else SaveMan.get_data("scroll_speed",1.0)
		var down_scroll_mult = 1.0 if not SaveMan.get_data("downscroll",false) else -1.0
		if data.time > Conductor.time + (2.2/(scrollspeed/Conductor.rate)):
			break
		
		var note:Note = temp_note.instantiate()
		note.column = data.column
		note.time = data.time
		note.sustain_length = max(data.length,0.0)
		note.og_sustain_length = max(data.length,0.0)
		note.scroll_speed = scrollspeed
		note.notefield = self
		notes.add_child(note)
		note.material.set_shader_parameter("note_color",note.note_colors[note.column%4])
		note.sprite.play(Strum.column_to_str(note.column))
		note.global_position.x = strums.get_child(note.column).global_position.x
		## sustain code by sword cube thx :3
		var distance: float = (450 * note.sustain_length) * (note.scroll_speed / Conductor.rate)
		var scale_shit: float = (note.scale.y / pow(scale.y,2.0))
		var tail_distance: float = (31 * down_scroll_mult)
		note.sustain.points[1].y = ((distance * down_scroll_mult) / scale_shit - tail_distance)
		note.tail.position = note.sustain.get_point_position(1) + Vector2(0,31)*down_scroll_mult
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
			note.missed = true
			note.queue_free()
			
		#note.global_position.y = (strum.global_position.y) - (450 * (Conductor.time - (note.time + (note.og_sustain_length - note.sustain_length)))) * (note.scroll_speed/Conductor.rate) * scale.y * down_scroll_mult
		note.position.y = (450 * (Conductor.time - (note.time + (note.og_sustain_length - note.sustain_length)))) * (note.scroll_speed/Conductor.rate) * scale.y * (down_scroll_mult * -1.0)
		if note.was_hit:
			note.position.y = 0
			var distance: float = (450 * note.sustain_length) * (note.scroll_speed / Conductor.rate)
			var scale_shit: float = (note.scale.y / pow(scale.y,2.0))
			var tail_distance: float = (31 * down_scroll_mult)
			note.sustain.points[1].y = ((distance * down_scroll_mult) / scale_shit - tail_distance)
			note.tail.position = note.sustain.get_point_position(1) + Vector2(0,31)*down_scroll_mult
		if note.missed:
			note.position.y = strum.position.y - (450 * (Conductor.time - (note.time + (note.og_sustain_length - note.sustain_length)))) * (note.scroll_speed/Conductor.rate) * down_scroll_mult
	
