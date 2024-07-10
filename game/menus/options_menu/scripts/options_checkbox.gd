extends CheckBox

@export var linked_field:String = "downscroll"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_pressed_no_signal(SaveMan.save.get(linked_field))
	pressed.connect(on_pressed)
	pass # Replace with function body.

func on_pressed():
	SaveMan.save.set(linked_field,button_pressed)
	SaveMan.save_data()
	pass
