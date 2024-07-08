extends CanvasLayer

@onready var player: VideoStreamPlayer = $VideoStreamPlayer
@onready var game: Game = Game.instance


func _ready() -> void:
	game.process_mode = Node.PROCESS_MODE_ALWAYS
	player.play()
	(func(): player.paused = true).call_deferred()


func _process(delta: float) -> void:
	player.paused = game.process_mode == Node.PROCESS_MODE_DISABLED
	if absf(player.stream_position - Conductor.time) > 0.015:
		player.stream_position = Conductor.time
	
	if game.song_started and player.paused:
		player.paused = false
		player.stream_position = Conductor.time


func _on_video_stream_player_finished() -> void:
	game.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
