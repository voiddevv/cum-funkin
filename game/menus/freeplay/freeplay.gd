extends Node2D

@onready var temp_item: Node2D = $temp_item
@export var freeplay_list:Array[FreeplayData] = []
@onready var menu_bg: Sprite2D = $CanvasLayer/menu_bg
@onready var camera: Camera2D = $Camera

var items:Array[Node2D] = []
var cur_item:int = 0:
	set(v):
		cur_item = wrapi(v,0,freeplay_list.size())
var cur_diffuculty:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count:int = 0
	for i:FreeplayData in freeplay_list:
		if i == null:
			i = FreeplayData.new()
		var item:Node2D = temp_item.duplicate()
		var item_icon:Sprite2D = item.get_node("icon")
		var item_label:RichTextLabel = item.get_node("icon/song_name")
		item_label.position.x = 75
		item.position.y += 160*count
		item.position.x += 40*count
		item_icon.texture = i.icon_texture
		item_icon.hframes = i.icon_frames
		item_label.text = i.song_name
		
		if not i.display_name.is_empty():
			item_label.text = i.display_name
		add_child(item)
		items.append(item)
		count += 1
	temp_item.queue_free()
	change_item(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	menu_bg.modulate = lerp(menu_bg.modulate,freeplay_list[cur_item].bg_color,delta*5.0)
	if Input.is_action_just_pressed("ui_down"):
		change_item(1)
	if Input.is_action_just_pressed("ui_up"):
		change_item(1)
	if Input.is_action_just_pressed("ui_accept"):
		select_song()
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.switch_scene("res://game/menus/main_menu.tscn")
	pass
func change_item(i:int):
	cur_item += i
	camera.position.y = items[cur_item].position.y
	camera.position.x = 640 + (cur_item * 40)
	
func select_song():
	var song_name = freeplay_list[cur_item].song_name
	SceneManager.switch_scene("res://gmae.tscn")
	Game.meta = Game.load_meta(song_name)
	Game.chart = Chart.load_chart(song_name,freeplay_list[cur_item].difficultys[cur_diffuculty],Game.meta.format)
	pass
