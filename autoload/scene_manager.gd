extends Node

@onready var trans: TextureRect = $trans
func switch_scene(scene_path:String):
	get_tree().paused = true
	trans.position.y = 720
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(trans,"position:y",-360,0.5)
	await tw.finished
	get_tree().change_scene_to_file(scene_path)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(trans,"position:y",720,0.5)
	await tw.finished
	get_tree().paused = not get_window().has_focus()
