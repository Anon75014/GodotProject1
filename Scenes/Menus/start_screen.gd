extends CanvasLayer

@onready var play = $"BoxContainer/VBoxContainer/BaseHBoxContainer/BasePlayButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	play.grab_focus()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Fight_node_1.tscn")

func _on_sim_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/FightMenu.tscn")

func _on_devmap_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/DevMap.tscn")

func _on_map_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/map.tscn")
	
	
# Processes keyboard events
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
