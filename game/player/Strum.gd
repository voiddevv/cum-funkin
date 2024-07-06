class_name Strum extends AnimatedSprite2D

@export var column:int = 0
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
			if material:
				material.set_shader_parameter("enabled",false)
			play("arrow%s"%column_to_str(column).to_upper())
		PRESSED:
			if material:
				material.set_shader_parameter("enabled",true)
			play("%s press"%column_to_str(column))
		CONFIRM:
			if material:
				material.set_shader_parameter("enabled",true)
			play("%s confirm"%column_to_str(column))
	pass
	
