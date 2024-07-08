extends BaseHud
@onready var health_bar: ProgressBar = $health_bar_overlay/bar
@onready var health_bar_overlay: TextureRect = $health_bar_overlay
@onready var cpu_icon: HealthIcon = $health_bar_overlay/bar/icons/cpu_icon
@onready var player_icon: HealthIcon = $health_bar_overlay/bar/icons/player_icon
@onready var score_text: Label = $"score text"

@onready var icons: Node2D = $health_bar_overlay/bar/icons

const icon_offset:float = 26.0
const countdown_streams = [preload("res://assets/countdown/intro3.ogg"), preload("res://assets/countdown/intro2.ogg"), preload("res://assets/countdown/intro1.ogg"), preload("res://assets/countdown/introGo.ogg")]
const countdown_textures = [preload("res://assets/countdown/ready.png"),preload("res://assets/countdown/set.png"),preload("res://assets/countdown/go.png")]
func reload_icon_textures():
	cpu_icon.texture = Game.instance.player_list[0].chars[0].icon
	player_icon.texture = Game.instance.player_list[1].chars[0].icon
	pass
func _ready() -> void:
	pivot_offset = Vector2(640,360)
	reload_icon_textures()
	if not SaveMan.get_data("downscroll"):
		health_bar_overlay.global_position.y = 720 - health_bar_overlay.global_position.y
	update_score_text()
	
func on_note_miss(player:Player,note:Note):
	if player.does_input:
		update_score_text()
		health_bar.value = stats.health
	
func on_note_hit(player:Player,note:Note):
	if player.does_input:
		update_score_text()
		health_bar.value = stats.health

		
	pass
func _process(delta: float) -> void:
	scale = lerp(scale,Vector2.ONE,delta*5.0)
	var percent = (1.0 - health_bar.value / health_bar.max_value)
	var bps = (Conductor.bpm/60.0)*4.0
	icons.scale = lerp(icons.scale,Vector2.ONE,delta*bps)
	icons.position.x = health_bar.size.x * percent
	player_icon.health = stats.health
	cpu_icon.health = 2.0 - player_icon.health
	pass
func update_score_text():
	score_text.text = "Score: %s; Combo Breaks: %s; Accuracy: %0.3f%%; Combo: %s (%s Max);"%[stats.score,stats.combo_breaks,stats.accuracy*100.0,stats.combo,stats.max_combo]
	pass
func on_beat_hit(beat:int):
	icons.scale += Vector2(0.2,0.2)
	
	if beat %4 == 0:
		scale += Vector2(0.05,0.05)
	pass
	
func on_step_hit(step:int):
	pass
