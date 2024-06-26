extends Node
@onready var game:Game = get_tree().current_scene as Game
@onready var camera:Camera2D = game.stage.camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Conductor.beat_hit.connect(bump)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera:
		camera.zoom = lerp(camera.zoom,Vector2.ONE * game.stage.zoom,delta*5.0)

func bump(beat:int):
	if beat%4 == 0:
		if camera:
			camera.zoom += Vector2(0.05,0.05)
