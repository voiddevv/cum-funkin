class_name Strum extends AnimatedSprite2D

var column:int = 0
enum {
	STATIC,
	PRESSED,
	CONFIRM,
}

static func column_to_str(c:int):
	return ["left","down","up","right"][c]
	

func play_anim(n:int,force:bool = true):
	if force:
		frame = 0
	match n:
		STATIC:
			play("arrow%s"%column_to_str(column).to_upper())
		PRESSED:
			play("%s press"%column_to_str(column))
		CONFIRM:
			play("%s confirm"%column_to_str(column))
	pass
	
