class_name ChartMeta extends Resource
@export var inst:AudioStream = null
@export var voices:Array[AudioStream] = []
@export var format:Chart.ChartFormat = 0
@export var stage:PackedScene = PackedScene.new()
@export var song_scripts:Array[Script] = [
	preload("res://assets/songs/default_song_scripts/cameraBump.gd"),
	preload("res://assets/songs/default_song_scripts/pause.gd")
]
@export var players:int = 2
