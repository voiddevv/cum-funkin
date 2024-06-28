extends Stage
@onready var overlay: Parallax2D = $Parallax2D4
@onready var trees: Sprite2D = $Parallax2D2/trees
@onready var mount_hog: Sprite2D = $"Parallax2D/mount hog"
@onready var floor_spr: Sprite2D = $Sprite2D
@onready var rocks: Sprite2D = $Parallax2D3/Rocks
@onready var bg: Sprite2D = $Parallax2D/bg
@onready var water: AnimatedSprite2D = $water
@onready var loops: AnimatedSprite2D = $Parallax2D2/loops
var new_loops:Sprite2D = Sprite2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Conductor.step_hit.connect(step)
	pass # Replace with function body.
func step(s):
	match s:
		864:
			change_bg()
			
			
			
	pass
func change_bg():
	overlay.queue_free()
	trees.texture = load("res://assets/stages/hog/hog 2/Plants.png")
	trees.position.x += 200
	trees.position.y += 60
	mount_hog.texture = load("res://assets/stages/hog/hog 2/Mountains.png")
	floor_spr.texture = load("res://assets/stages/hog/hog 2/Floor.png")
	floor_spr.position -= Vector2(-200, -30)
	rocks.texture = load("res://assets/stages/hog/hog 2/Rocks.png")
	bg.texture = load("res://assets/stages/hog/hog 2/Sunset.png")
	bg.position.y += 300.0
	water.sprite_frames = load("res://assets/stages/hog/hog 2/Waterfalls.res")
	water.play("British instance 1")
	new_loops.texture = load("res://assets/stages/hog/hog 2/Hills.png")
	new_loops.position = Vector2(0, 230)
	new_loops.centered = false
	loops.add_sibling(new_loops)
	loops.queue_free()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
