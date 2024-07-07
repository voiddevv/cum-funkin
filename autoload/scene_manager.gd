extends Node2D

@onready var trans: TextureRect = $CanvasLayer/trans
func switch_scene(scene_path:String):
	var new_scene:PackedScene = load(scene_path)
	var dumb_shit = load(scene_path).instantiate()
	trans.global_position.y = 720
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(trans,"global_position:y",-360,0.5)
	await tw.finished
	get_tree().paused = true
	get_tree().change_scene_to_packed(new_scene)
	for i in 10:
		await get_tree().physics_frame
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(trans,"global_position:y",720,0.4)
	await tw.finished
	get_tree().paused = not get_window().has_focus()
	
	
