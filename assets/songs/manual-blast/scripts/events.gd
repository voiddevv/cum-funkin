extends Node
@onready var game:Game = get_tree().current_scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Conductor.step_hit.connect(step)
	print("song script ready")
	print(game)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func step(_step:int) -> void:
	if _step == 750:
		print('swap to burned person')
		var newchar:Character = load("res://game/characters/scorched.tscn").instantiate()
		game.add_child(newchar)
		var cpu_player:Player = game.players.get_child(0) as Player
		for i in cpu_player.chars:
			i.queue_free()
		cpu_player.chars.clear()
		cpu_player.chars.append(newchar)
		newchar.position = game.stage.cpu.position
