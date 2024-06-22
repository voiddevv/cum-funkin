class_name NoteData extends Resource
@export var time:float
@export var column:int
@export var length:float
@export var type:StringName
@export var player:int
func _init(t:float,c:int,l:float,titie:StringName,p:int):
	self.time = t
	self.column = c
	self.length = l
	self.type = titie
	self.player = p
## TODO IMPLMENT THIS
func get_renderd_position(strum:Strum,scroll_speed:float) -> Vector2:
	var _y = strum.global_position.y + (450 * (Conductor.time - time)) * scroll_speed*0.7
	if SaveMan.get_data("downscroll",false):
		_y = strum.global_position.y - (450 * (Conductor.time - time)) * scroll_speed*0.7
	var _x = strum.global_position.x
	return Vector2(_x,_y)
	
	
