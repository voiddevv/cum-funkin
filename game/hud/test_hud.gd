extends BaseHud

func on_note_miss(player:Player,note:Note):
	pass
	
func on_note_hit(player:Player,note:Note):
	if player.does_input and not note.sustain_ticking:
		print("u hit a note im da hud")
	pass
	
func on_beat_hit(beat:int):
	pass
	
func on_step_hit(step:int):
	pass
