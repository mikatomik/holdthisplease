extends Control

var click_pos : Vector2
var clipboard : String = ""

const CONFIG_FILEPATH = "user://config.cfg"

onready var text_box = $main_screen/TextEdit

func _ready():
	$options.visible = false
	load_config()
	text_box.grab_focus()

func _process(_delta):
	text_box.rect_min_size.y = OS.window_size.y - 25
	#Make window moveable by holding middle click
	if Input.is_action_just_pressed("middle_click"):
		click_pos = get_local_mouse_position()
	if Input.is_action_pressed("middle_click"):
		OS.set_window_position(OS.get_window_position() + get_global_mouse_position() - click_pos)
		
	if Input.is_action_just_pressed("always_ontop"):
		OS.set_window_always_on_top(!OS.is_window_always_on_top())
		
func load_config():
	var config_file = ConfigFile.new()
	var error = config_file.load(CONFIG_FILEPATH)
	if error != OK:
		return
	else:
		text_box.show_line_numbers = config_file.get_value("options", "show_line_number", false)
		text_box.draw_tabs = config_file.get_value("options", "show_tabs", false)
		text_box.highlight_current_line = config_file.get_value("options", "highlight_current_line", false)
		text_box.highlight_all_occurrences = config_file.get_value("options", "highlight_selection_duplicates", false)
		text_box.minimap_draw = config_file.get_value("options", "minimap_draw", false)
		text_box.material = config_file.get_value("options", "super_secret_party_mode", false)
		OS.set_window_always_on_top(config_file.get_value("options", "always_on_top", true))
		OS.window_size = config_file.get_value("options", "window_size", Vector2(300, 500))
		clipboard = config_file.get_value("memory", "text", "")
		text_box.text = clipboard
		$options/VBoxContainer/draw_minimap.set_pressed_no_signal(text_box.minimap_draw)
		$options/VBoxContainer/show_line_number.set_pressed_no_signal(text_box.show_line_numbers)
		$options/VBoxContainer/show_tabs.set_pressed_no_signal(text_box.draw_tabs)
		$options/VBoxContainer/hightlight_current_line.set_pressed_no_signal(text_box.highlight_current_line)
		$options/VBoxContainer/highlight_selection_instances.set_pressed_no_signal(text_box.highlight_all_occurrences)
		

func save_config():
	var config_file = ConfigFile.new()
	config_file.load(CONFIG_FILEPATH)
	config_file.set_value("memory", "text", clipboard)
	config_file.set_value("options", "show_line_number", text_box.show_line_numbers)
	config_file.set_value("options", "show_tabs", text_box.draw_tabs)
	config_file.set_value("options", "highlight_current_line", text_box.highlight_current_line)
	config_file.set_value("options", "highlight_selection_duplicates", text_box.highlight_all_occurrences)
	config_file.set_value("options", "always_on_top", OS.is_window_always_on_top())
	config_file.set_value("options", "window_size", OS.window_size)
	config_file.set_value("options", "minimap_draw", text_box.minimap_draw)
	config_file.save(CONFIG_FILEPATH)
	

func _on_exit_button_pressed():
	clipboard = text_box.text
	save_config()
	get_tree().quit()


func _on_options_pressed():
	$main_screen.visible = false
	$options.visible = true


func _on_back_pressed():
	$options.visible = false
	$main_screen.visible = true
	text_box.grab_focus()


func _on_show_line_number_toggled(_button_pressed):
	text_box.show_line_numbers = !text_box.show_line_numbers


func _on_show_tabs_toggled(_button_pressed):
	text_box.draw_tabs = !text_box.draw_tabs


# warning-ignore:unused_argument
func _on_hightlight_current_line_toggled(button_pressed):
	text_box.highlight_current_line = !text_box.highlight_current_line


# warning-ignore:unused_argument
func _on_highlight_selection_instances_toggled(button_pressed):
	text_box.highlight_all_occurrences = !text_box.highlight_all_occurrences


func _on_draw_minimap_toggled(_button_pressed):
	text_box.minimap_draw = !text_box.minimap_draw
