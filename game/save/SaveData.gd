class_name SaveDat extends Object
@export var fps:int = 120:
	set(v): 
		fps = v
		Engine.max_fps = v
@export var vsync:bool = false:
	set(v):
		vsync = v
		if v:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
@export var downscroll:bool = true
@export var center_notefeild:bool = false
@export var scroll_speed:float = 1.0
@export var keybinds:Dictionary = {
	"note_left" : ["left","d"],
	"note_down" : ["down","f"],
	"note_up" : ["up","j"],
	"note_right" : ["right","k"],
}
