extends Panel

# VARIABLES #
@onready var sprite_data:AnimatedSprite2D = $"../SpriteData"
@onready var fps_box:LineEdit = $FPS

var path:StringName = "res://Assets/Images/Characters/bf/assets"
var fps:int = 24
var looped:bool = false
var optimized:bool = true

func convert_xml() -> void:
	if path == "":
		return
	
	var base_path:StringName = path.get_basename()
	var texture:Texture = load(base_path + ".png")
	var image:Image = null
	var image_texture:ImageTexture = null
	
	if texture == null:
		print(base_path + " loading failed.")
		return
	
	var frames:SpriteFrames = SpriteFrames.new()
	frames.remove_animation("default")
	
	var xml:XMLParser = XMLParser.new()
	xml.open(base_path + ".xml")
	
	sprite_data.frames = frames
	
	var previous_atlas:AtlasTexture
	var previous_rect:Rect2
	var them:Dictionary = {}
	
	while xml.read() == OK:
		if xml.get_node_type() != XMLParser.NODE_TEXT:
			var node_name:StringName = xml.get_node_name()
			
			if node_name.to_lower() == "subtexture":
				var frame_data:AtlasTexture
				var rotated: bool = xml.get_named_attribute_value_safe('rotated') == 'true'
				
				var animation_name = xml.get_named_attribute_value("name")
				var animation_id = animation_name.substr(len(animation_name) - 4).to_int()
				
				animation_name = animation_name.left(len(animation_name) - 4)
				
				var frame_rect:Rect2 = Rect2(
					Vector2(
						xml.get_named_attribute_value("x").to_float(),
						xml.get_named_attribute_value("y").to_float()
					),
					Vector2(
						xml.get_named_attribute_value("width").to_float(),
						xml.get_named_attribute_value("height").to_float()
					)
				)
				
				if optimized and previous_rect == frame_rect:
					frame_data = previous_atlas
				else:
					frame_data = AtlasTexture.new()
					if rotated:
						if not (image and image_texture):
							image = texture.get_image()
							image.decompress()
							image_texture = ImageTexture.create_from_image(image)
						
						frame_data.atlas = image_texture
					else:
						frame_data.atlas = texture
					
					frame_data.region = frame_rect
					
					var margin:Rect2 = Rect2(-1, -1, -1, -1)
					
					var raw_frame_x:int = xml.get_named_attribute_value("frameX").to_int()
					var raw_frame_y:int = xml.get_named_attribute_value("frameY").to_int()
					var raw_frame_width:int = xml.get_named_attribute_value("frameWidth").to_int()
					var raw_frame_height:int = xml.get_named_attribute_value("frameHeight").to_int()
					
					if xml.has_attribute("frameX"):
						var frame_size_data:Vector2 = Vector2(
							raw_frame_width,
							raw_frame_height
						)
						
						if frame_size_data == Vector2.ZERO:
							frame_size_data = frame_rect.size
						
						margin = Rect2(Vector2(-raw_frame_x, -raw_frame_y),
								Vector2(raw_frame_width - frame_rect.size.x,
										raw_frame_height - frame_rect.size.y)
						)
						
						if margin.size.x < abs(margin.position.x):
							margin.size.x = abs(margin.position.x)
						if margin.size.y < abs(margin.position.y):
							margin.size.y = abs(margin.position.y)
						
						frame_data.margin = margin
						
					if rotated:
						var atlas_image: Image = frame_data.get_image()
						atlas_image.rotate_90(COUNTERCLOCKWISE)
						
						var atlas_texture: ImageTexture = ImageTexture.create_from_image(atlas_image)
						if margin != Rect2(-1, -1, -1, -1):
							# source is based on the frame, not the whole texture.
							# This is because rotating the image messes with the offests,
							# so we just recalculate the margins basically.
							# :]
							var source:Rect2 = Rect2(Vector2.ZERO, atlas_texture.get_size())
							var offsets:Rect2 = Rect2(raw_frame_x, raw_frame_y, raw_frame_width, raw_frame_height)

							frame_data = AtlasTexture.new()
							frame_data.atlas = atlas_texture
							frame_data.region = source
							
							margin = Rect2i(
								-offsets.position.x, -offsets.position.y,
								offsets.size.x - source.size.x, offsets.size.y - source.size.y)
							
							frame_data.margin = margin
					
					frame_data.filter_clip = true
					
					previous_atlas = frame_data
					previous_rect = frame_rect
				
				if not frames.has_animation(animation_name):
					frames.add_animation(animation_name)
					frames.set_animation_loop(animation_name, looped)
					frames.set_animation_speed(animation_name, fps)
					them[animation_name] = []
				
				them[animation_name].append({"name": animation_name, "id": animation_id, "data": frame_data})
	
	for shit:Array in them.values():
		shit.sort_custom(func(a, b):
			return a.id < b.id
		)
		for f in shit:
			frames.add_frame(f.name, f.data)
	
	ResourceSaver.save(frames, base_path + ".res", ResourceSaver.FLAG_COMPRESS)
	
	var framerate_multiplier:float = (1.0 / fps)
	
	for anim in frames.animations:
		sprite_data.play(anim.name)
		await get_tree().create_timer(framerate_multiplier * frames.get_frame_count(anim.name)).timeout

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# funny signal shits
func set_path(new_path:StringName) -> void:
	path = new_path

func set_fps(new_fps:StringName) -> void:
	fps = new_fps.to_int()

func set_looped(new_looped:bool) -> void:
	looped = new_looped

func set_optimized(new_optimized:bool) -> void:
	optimized = new_optimized
