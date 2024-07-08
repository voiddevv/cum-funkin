extends Node


var stupid: Node


func _ready() -> void:
	stupid = preload('res://assets/songs/silly-billy/scripts/video.tscn').instantiate()
	add_child(stupid)
	Conductor.step_hit.connect(_on_step_hit)


func _on_step_hit(step: int) -> void:
	if not is_instance_valid(stupid):
		queue_free()
