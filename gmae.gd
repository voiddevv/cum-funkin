class_name Game extends Node2D
static var chart:Chart = null
@onready var ui_layer = $"UI Layer"
@onready var tracks = $tracks
@onready var players = $"UI Layer/players"
var song_player:AudioStreamPlayer = null ## is set on play music shit

func _ready():
	Conductor.beat_hit.connect(beat_hitt)
	Conductor.step_hit.connect(step_hitt)
	chart = Chart.load_chart("manual-blast","hard")
	for i in chart.bpms:
		Conductor.queue_bpm_change(i)
	Conductor.bpm = chart.bpms[0].bpm
	var q = 0
	for i:Player in players.get_children():
		if not i: continue
		i.id = q
		i.notefield.note_data = chart.notes.duplicate()
		i.notefield.queue_notes()
		q += 1
	
	
#region music shits
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = AudioStreamSynchronized.new()
	player.stream.stream_count = 1 + chart.meta.voices.size()
	player.bus = "music"
	player.stream.set_sync_stream(0,chart.meta.inst)
	Conductor.audio = player
	tracks.add_child(player)
	var s = 0
	for i in chart.meta.voices:
		player.stream.set_sync_stream(s+1,i)
		s += 1
	player.play()
	song_player = player
		
#endregion
#region stage shits
	if !chart.meta.stage.can_instantiate():
		var col = ColorRect.new()
		col.size = Vector2(1920,1080)
		col.color = Color.BLACK
		chart.meta.stage.pack(col)
	var stage:Stage = chart.meta.stage.instantiate()
	add_child(stage,true,Node.INTERNAL_MODE_FRONT)
	
#region character shits
	var bf:Character = preload("res://game/characters/bf.tscn").instantiate()
	bf.position = stage.player.position
	var dad =  preload("res://game/characters/dad.tscn").instantiate()
	dad.position = stage.cpu.position
	stage.add_child(bf)
	stage.add_child(dad)
	players.get_child(1).chars.append(bf)
	players.get_child(0).chars.append(dad)
#endregion
	
	
#endregion
var last_stream_time:float = 0.0
func _process(delta):
	
	if last_stream_time != 0:
		if song_player.get_playback_position() < last_stream_time:
			get_tree().change_scene_to_file("res://titlescreen.tscn")
	# some dumb code to fix sync stream for beta 2 till this gets patched :3
	
	Conductor.update()
	last_stream_time = song_player.get_playback_position()
	

func beat_hitt(b):
	pass
	#print(b)

func step_hitt(b):
	pass
	#print(b)

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_F3:
			song_player.seek(song_player.get_playback_position() + 30)
			Conductor.time += 30.0
			Conductor.update()
		if event.keycode == KEY_F5:
			if not event.is_echo():
				if event.is_pressed(): 
					Conductor.time = 0
					get_tree().reload_current_scene()
