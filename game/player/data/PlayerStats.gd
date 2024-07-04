class_name PlayerStats extends Resource
var health:float = 1.0:
	set(v):
		health = min(v,2.0)
		
var score:int = 0
var combo:int = 0:
	set(v):
		combo = v
		max_combo = maxi(combo,max_combo)
var max_combo:int = 0
var combo_breaks:int = 0
var accuracy:float = 0.0:
	get:
		if notes_hit == 0:
			return 0.0
		return notes_hit / float(notes_hit + combo_breaks)
var notes_hit:int = 0
