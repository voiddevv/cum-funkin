class_name PlayerStats extends Resource
var health:float = 1.0:
	set(v):
		health = min(v,2.0)
		
var score:int = 0
var combo_breaks:int = 0
var accuracy:float = 0.0
var notes_hit:int = 0
