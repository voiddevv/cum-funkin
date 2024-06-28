extends Node
@onready var game:Game = get_tree().current_scene
var preloaded_stuffs = [
	load("res://assets/characters/hog/ScorchedGlitch.res"),
	load("res://assets/characters/hog/scorchedwithglitch2.res"),
	load("res://assets/characters/hog/scorched.res")]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Conductor.step_hit.connect(step)
	print("song script ready")
	print(game)
	pass # Replace with function body.

func _exit_tree() -> void:
	for i:Resource in preloaded_stuffs:
		i.unreference()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func step(_step:int) -> void:
	if _step == 864:
		var newchar = preload("res://game/characters/scorched.tscn").instantiate()
		game.add_child(newchar)
		var cpu_player:Player = game.players.get_child(0) as Player
		for i in cpu_player.chars:
			i.queue_free()
		cpu_player.chars.clear()
		cpu_player.chars.append(newchar)
		newchar.position = game.stage.cpu.position
	if _step == 4060:
		var newchar = preload("res://game/characters/scorched_glitch.tscn").instantiate()
		game.add_child(newchar)
		var cpu_player:Player = game.players.get_child(0) as Player
		for i in cpu_player.chars:
			i.queue_free()
		cpu_player.chars.clear()
		cpu_player.chars.append(newchar)
		newchar.position = game.stage.cpu.position
