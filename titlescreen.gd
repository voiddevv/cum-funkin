extends Node2D

@onready var icon = $Icon

# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.beat_hit.connect(beat)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bz = lerp(icon.scale,Vector2.ONE,pow(delta*19.0,1.2))
	icon.scale = bz
	Conductor.update()
func beat(b):
	print("hi")
	icon.scale = Vector2.ONE*1.2
