extends Button

var old_text = ""
@export var linked_bind = "note_left"
var is_waiting:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_pressed)
	text = linked_bind + ":" + SaveMan.save.keybinds.get(linked_bind)[1].to_upper()
	pass # Replace with function body.
func on_pressed():
	text = "press key"
	is_waiting = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if is_waiting:
		if event is InputEventKey:
			if not event.is_echo() and event.is_pressed():
				print(OS.get_keycode_string(event.keycode))
				SaveMan.save.keybinds[linked_bind][1] = OS.get_keycode_string(event.keycode)
				SaveMan.save_data()
				SaveMan.init_binds()
				is_waiting = false
				text = linked_bind + ":" + SaveMan.save.keybinds.get(linked_bind)[1].to_upper()
				#text = old_text
