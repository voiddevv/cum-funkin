class_name NoteData extends Resource
@export var time:float
@export var column:int
@export var length:float:
	set(v):
		length = max(v,0.0)
		
@export var type:StringName
@export var player:int
func _init(t:float,c:int,l:float,titie:StringName,p:int):
	self.time = t
	self.column = c
	self.length = l
	self.type = titie
	self.player = p
