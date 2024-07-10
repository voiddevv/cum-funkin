class_name Game extends Node2D
static var meta:ChartMeta
static var chart:Chart = null
static var play_mode = 0
static var instance:Game = null
@onready var ui_layer = $"UI Layer"
@onready var tracks = $tracks
@onready var event_manager: EventHandler = %event_manager
@onready var hud: BaseHud = $"UI Layer/HUD"

var song_player:AudioStreamPlayer = null ## is set on play music shit
var stage:Stage = null
var song_script_objs:Array[Object] = []
var player_list:Array[Player] = []
static var shaders:bool = true
var song_started:bool = false
enum PlayMode {
	FREEPLAY = 0,
	STORY = 1
}
func beat_hit(beat:int):
	hud.on_beat_hit(beat)
static func load_meta(song_name:String) -> ChartMeta:
	var meta_path:String = "res://assets/songs/%s/meta.tres"%song_name
	print(meta_path)
	if ResourceLoader.exists(meta_path):
		return ResourceLoader.load(meta_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	else:
		return ChartMeta.new()
		
func _init() -> void:
	Conductor.reset()
	if meta == null:
		meta = load_meta("silly-billy")
	if chart == null:
		chart = Chart.load_chart("silly-billy", "normal")
func _ready():
	event_manager.events = meta.events + chart.events
	event_manager.events.sort_custom(func(a,b): return a.time < b.time)
	Conductor.beat_hit.connect(beat_hit)
	hud.queue_free()
	
	hud = meta.hud.instantiate()
	for i in meta.players.size():
		var config:PlayerConfig = meta.players[i]
		
		var nfield:NoteField = NoteField.new()
		nfield.global_position.y = 100
		nfield.global_position.x = 110*3 + 640 * i
		
		nfield.strums = load("res://game/player/strumlines/normal.tscn").instantiate()
		hud.add_child(nfield)
		var pler:Player = Player.new(nfield,config.has_input,config.autoplay)
		if SaveMan.get_data("opponent_play"):
			pler.does_input = not pler.does_input
			pler.autoplay = not pler.autoplay
			
		pler.id = i
		nfield.player = pler
		nfield.note_data = chart.notes.duplicate()

		player_list.append(pler)
		if pler.does_input:
			hud.stats = pler.stats
		hud.add_child(pler)
		if hud:
			hud.pivot_offset = hud.size / 2.0
	for i in chart.bpms:
		Conductor.queue_bpm_change(i)
	Conductor.bpm = chart.bpms[0].bpm
	meta.events.sort_custom(func(a,b): return a.time < b.time)
	var cool_players = player_list.filter(func(p:Player): return p.does_input)
	## it is possible for you to make more than 1 player with input, thats just dumb
	var p = cool_players.front()
	if SaveMan.get_data("autoplay"):
		p.autoplay = true
	if SaveMan.get_data("center_notefield"):
		for i in player_list:
			i.notefield.visible = false
		p.notefield.visible = true
		p.notefield.position.x = 640
			

	instance = self
#region music shits
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = AudioStreamSynchronized.new()
	player.stream.stream_count = 1 + Game.meta.voices.size()
	player.bus = "music"
	player.stream.set_sync_stream(0,meta.inst)
	Conductor.audio = player
	tracks.add_child(player)
	var s = 0
	for i in Game.meta.voices:
		player.stream.set_sync_stream(s+1,i)
		s += 1
	song_player = player
		
#endregion
#region stage shits
	if !meta.stage.can_instantiate():
		var col = ColorRect.new()
		col.size = Vector2(1920,1080)
		col.color = Color.BLACK
		chart.meta.stage.pack(col)
	stage = meta.stage.instantiate()
	add_child(stage,true,Node.INTERNAL_MODE_FRONT)
#endregion
#region character shits
	if meta.player_character:
		if meta.player_character.can_instantiate():
			var bf:Character = meta.player_character.instantiate()
			bf.position = stage.player.position
			stage.add_child(bf)
			player_list[1].chars.append(bf)
			
	if meta.cpu_character:
		if meta.cpu_character.can_instantiate():
			var dad = meta.cpu_character.instantiate()
			dad.position = stage.cpu.position
			stage.add_child(dad)
			player_list[0].chars.append(dad)
#endregion
#region song scripts shits
	for i:Script in meta.song_scripts:
		var type = i.get_instance_base_type()
		var obj = ClassDB.instantiate(type)
		obj.set_script(i)
		if obj is Node:
			add_child(obj)
		song_script_objs.append(obj)
#endregion
	ui_layer.add_child(hud)

var last_stream_time:float = 0.0
var cur_event:int = 0
func _process(delta):
	Conductor.time += delta
	if Conductor.time >= 0.0 and not song_started:
		song_started = true
		Conductor.audio.play()
	if not song_started: 
		return
	if last_stream_time != 0:
		if (song_player.get_playback_position()) < last_stream_time:
			end_song()
		# some dumb code to fix sync stream for beta 2 till this gets patched :3
	
	last_stream_time = (song_player.get_playback_position())

func end_song():
	## unload cus erm sigma
	chart = null
	meta = null
	match play_mode:
		PlayMode.FREEPLAY:
			SceneManager.switch_scene("res://game/menus/freeplay/freeplay.tscn")
		PlayMode.STORY:
			SceneManager.switch_scene("res://game/menus/main_menu.tscn")
			
			
func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			if event.keycode == KEY_F3:
				skip_time(Conductor.time + 30.0)
			if event.keycode == KEY_F5:
				if not event.is_echo():
					if event.is_pressed():
						meta = load_meta(chart.song_name)
						Conductor.audio.stop()
						Conductor.reset() 
						get_tree().reload_current_scene()
						
						
	
func _exit_tree() -> void:
	for i:Object in song_script_objs:
		if is_instance_valid(i):
			i.free()
		
func skip_time(time_to:float):
	for i in player_list:
		song_player.seek(time_to)
		Conductor.time = time_to
		i.notefield.queue_notes()
		if not i.autoplay:
			for n:Note in i.notefield.notes.get_children():
				if (n.time) - Conductor.time < n.og_sustain_length + 2.2:
					n.free()
