class_name Stage extends Node2D
## zoom which the camera lerps to
@export var zoom:float = 1.05
## speed which camera lerps zoom
@export var lerp_speed:float = 5.0
## camera of stage
@export var camera:Camera2D = null
@export_category("chars")
## player position, if null will remove player
@export var player:Marker2D
## cpu position, if null will remove cpu
@export var cpu:Marker2D
## speaker position, if null will remove speaker
@export var speaker:Marker2D
 
# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.beat_hit.connect(beat_hit)
	if camera:
		camera.make_current()
	pass # Replace with function body.

func beat_hit(beat:int):
	if beat%4 == 0:
		if camera:
			camera.zoom += Vector2.ONE*0.05
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera:
		camera.zoom = lerp(camera.zoom,Vector2(zoom,zoom),delta*lerp_speed)
	pass
