extends Node2D

var volume:float:
	set(v):
		volume = clampf(v,0.0,1.0)
		AudioServer.set_bus_volume_db(0,linear_to_db(volume))
		print(linear_to_db(volume))
		SaveMan.set_data("volume",volume)
		SaveMan.save_data()
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volume_down"):
		print("hai!!")
		volume -= 0.05
	if event.is_action_pressed("volume_up"):
		print("hai!")
		volume += 0.05
