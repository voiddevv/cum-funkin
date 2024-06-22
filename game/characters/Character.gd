class_name Character extends Node2D
@export var icon:Texture
@export var sing_length:float = 4.0
@export var dance_steps:PackedStringArray = ["idle"]
@export_category("nodes")
@export var anim_player:AnimationPlayer
@export var sprite:AnimatedSprite2D
var _cur_anim:StringName = "NONE"
var _sing_timer:float = 0.0
var cur_dance_step:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.beat_hit.connect(on_beat)
	dance()
	pass # Replace with function body.

func play_anim(anim:StringName,force:bool = false) -> void:
	assert(is_instance_valid(sprite),"character sprite invalid")
	if force:
		sprite.frame = 0
	if not anim_player.has_animation(anim):
		push_error("character does not have anim named - %s"%anim)
		return
	_cur_anim = anim
	anim_player.play(anim)
func dance():
	_sing_timer = 0
	play_anim(dance_steps[cur_dance_step%dance_steps.size()])
func sing(dir:int):
	_sing_timer = 0
	play_anim("sing_%s"%Strum.column_to_str(dir),true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _cur_anim.begins_with("sing"):
		_sing_timer += delta
	
	if _sing_timer > Conductor.step_crochet * sing_length:
		if _cur_anim.begins_with("sing"):
			dance()
	pass
func on_beat(beat:int):
	if not _cur_anim.begins_with("sing"):
		dance()
