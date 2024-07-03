extends BaseHud
@onready var health_bar: ProgressBar = $health_bar_overlay/bar
@onready var health_bar_overlay: TextureRect = $health_bar_overlay
@onready var cpu_icon: Sprite2D = $health_bar_overlay/bar/icons/cpu_icon
@onready var player_icon: Sprite2D = $health_bar_overlay/bar/icons/player_icon

@onready var icons: Node2D = $health_bar_overlay/bar/icons

const icon_offset:float = 26.0

func _ready() -> void:
	
	if not SaveMan.get_data("downscroll"):
		health_bar_overlay.global_position.y = 720 - health_bar_overlay.global_position.y
func on_note_miss(player:Player,note:Note):
	if player.does_input:
		health_bar.value = stats.health
	
func on_note_hit(player:Player,note:Note):
	if player.does_input:
		health_bar.value = stats.health
	pass
func _process(delta: float) -> void:
	scale = lerp(scale,Vector2.ONE,delta*5.0)
	var percent = (1.0 - health_bar.value / health_bar.max_value)
	icons.scale = lerp(icons.scale,Vector2.ONE,delta*19.0)
	icons.global_position.x = (health_bar.global_position.x *  scale.x + (health_bar.size.x * percent))
	pass
func on_beat_hit(beat:int):
	icons.scale += Vector2(0.2,0.2)
	
	if beat %4 == 0:
		scale += Vector2(0.05,0.05)
	pass
	
func on_step_hit(step:int):
	pass
