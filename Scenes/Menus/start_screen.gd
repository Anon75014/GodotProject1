extends CanvasLayer


var focusedButton: Button = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer/VBoxContainer/HBoxContainer/PlayButton").grab_focus()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Fight_node_1.tscn")

func _on_play2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Fight_node_2.tscn")

func _on_map_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/map.tscn")
	
	
# Processes keyboard events
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	#if Input.is_action_pressed("ui_focus_next") \
		#or Input.is_key_pressed(KEY_DOWN) \
		#or Input.is_key_pressed(KEY_UP):
		#pass
		
