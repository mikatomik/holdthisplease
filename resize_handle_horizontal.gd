extends Control

var mouse_pos : Vector2
var window_position : Vector2
var window_size : Vector2
var following : bool = false

func _process(_delta):
	if following:
		OS.window_size.x = get_global_mouse_position().x - mouse_pos.x
		if OS.window_size.x < 300:
			OS.window_size.x = 300


func _on_resize_handle_horizontal_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			mouse_pos = get_local_mouse_position()
			window_position = OS.window_position
			window_size = OS.window_size
			following = !following
