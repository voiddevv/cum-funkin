class_name Game extends Node2D
static var chart:Chart = null
static var instance:Game = null
@onready var ui_layer = $"UI Layer"
@onready var tracks = $tracks
@onready var event_manager: EventHandler = %event_manager
@onready var hud: BaseHud = %HUD

var song_player:AudioStreamPlayer = null ## is set on play music shit
var stage:Stage = null
var song_script_objs:Array[Object] = []
var player_list:Array[Player] = []
static var shaders:bool = true
func _ready():
	Conductor.reset()
	chart = Chart.load_chart("manual-blast","hard")
	hud = chart.meta.hud.instantiate()
	for i in chart.meta.players.size():
		var config:PlayerConfig = chart.meta.players[i]
		
		var nfield:NoteField = NoteField.new()
		nfield.global_position.y = 100
		nfield.global_position.x = 110*3 + 640 * i
		ui_layer.add_child(nfield)
		var pler:Player = Player.new(nfield,config.has_input,config.autoplay)
		pler.id = i
		nfield.player = pler
		nfield.note_data = chart.notes.duplicate()

		player_list.append(pler)
		ui_layer.add_child(pler)
		if hud:
			pler.notehit.connect(hud.on_note_hit)
	for i in chart.bpms:
		Conductor.queue_bpm_change(i)
	Conductor.bpm = chart.bpms[0].bpm
	#var q = 0
	#for i:Player in players.get_children():
		#if not i: continue
		#i.id = q
		#i.notefield.note_data = chart.notes.duplicate()
		#i.notefield.queue_notes()
		#q += 1
	chart.meta.events.sort_custom(func(a,b): return a.time < b.time)
	instance = self

	
	
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
	stage = chart.meta.stage.instantiate()
	add_child(stage,true,Node.INTERNAL_MODE_FRONT)
#endregion
#region character shits
	if chart.meta.player_character:
		if chart.meta.player_character.can_instantiate():
			var bf:Character = chart.meta.player_character.instantiate()
			bf.position = stage.player.position
			stage.add_child(bf)
			player_list[1].chars.append(bf)
			
	if chart.meta.cpu_character:
		if chart.meta.cpu_character.can_instantiate():
			var dad = chart.meta.cpu_character.instantiate()
			dad.position = stage.cpu.position
			stage.add_child(dad)
			player_list[0].chars.append(dad)
#endregion
#region song scripts shits
	for i:Script in chart.meta.song_scripts:
		var type = i.get_instance_base_type()
		var obj = ClassDB.instantiate(type)
		print(obj)
		obj.set_script(i)
		print(i)
		if obj is Node:
			add_child(obj)
		song_script_objs.append(obj)
#endregion
var last_stream_time:float = 0.0
var cur_event:int = 0
func _process(delta):
	if last_stream_time != 0:
		if (song_player.get_playback_position()) < last_stream_time:
			get_tree().change_scene_to_file("res://game/menus/titlescreen.tscn")
		# some dumb code to fix sync stream for beta 2 till this gets patched :3
	
	Conductor.update(delta)
	last_stream_time = (song_player.get_playback_position())


func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_F3:
				song_player.seek(song_player.get_playback_position() + 30)
				Conductor.time += 30.0
				
				Conductor.update()
			if event.keycode == KEY_F5:
				if not event.is_echo():
					if event.is_pressed(): 
						Conductor.reset()
						get_tree().reload_current_scene()
	
func _exit_tree() -> void:
	chart = null
	for i:Object in song_script_objs:
		i.free()
		
