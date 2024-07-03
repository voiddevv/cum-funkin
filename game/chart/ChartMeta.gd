class_name ChartMeta extends Resource
@export_category("audio")
@export var inst:AudioStream = null
@export var voices:Array[AudioStream] = []

@export_category("characters")
@export var cpu_character:PackedScene
@export var player_character:PackedScene
@export var speaker_character:PackedScene

@export_category("script")
@export var song_scripts:Array[Script] = [
	preload("res://assets/songs/default_song_scripts/cameraBump.gd"),
	preload("res://assets/songs/default_song_scripts/pause.gd")
]
@export var script_packs:Array[Script]

@export_category("other")
@export var events:Array[Event] = []
@export var format:Chart.ChartFormat = 0
@export var stage:PackedScene = PackedScene.new()
@export var players:Array[PlayerConfig] = []
@export var hud:PackedScene = null
