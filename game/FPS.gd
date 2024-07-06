extends CanvasLayer
@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps = Engine.get_frames_per_second()
	var ram = String.humanize_size(OS.get_static_memory_usage())
	var vram = String.humanize_size(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
	label.text = "FPS: %s\nram:%s\nvram:%s"%[fps,ram,vram]
