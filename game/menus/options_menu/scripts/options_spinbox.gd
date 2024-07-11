extends SpinBox
@export var linked_field:String = "fps"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_value_no_signal(SaveMan.save.get(linked_field) as float)
	value_changed.connect(on_changed)
	pass # Replace with function body.
func on_changed(v:float):
	SaveMan.save.set(linked_field,v)
	SaveMan.save_data()
	print(v)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
