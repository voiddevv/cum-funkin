extends Node2D
@onready var keybinds_button: Button = $"UI/pages/gameplay/VBoxContainer/keybinds button"
@onready var ui: CanvasLayer = $UI
@onready var pages: Control = $UI/pages
var can_exit:bool = true
var keybinds_menu:Control = preload("res://game/menus/options_menu/keybinds_menu.tscn").instantiate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.add_child(keybinds_menu)
	keybinds_menu.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_exit:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			SceneManager.switch_scene("res://game/menus/main_menu.tscn")
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			await create_tween().tween_property(keybinds_menu,"modulate:a",0.0,0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).finished
			can_exit = true
			pages.visible = true
			keybinds_menu.visible = false
	pass


func _on_keybinds_button_pressed() -> void:
	can_exit = false
	pages.visible = false
	keybinds_menu.visible = true
	keybinds_menu.modulate.a = 1.0
	pass # Replace with function body.
