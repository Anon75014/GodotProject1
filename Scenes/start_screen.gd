extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Fight_node_1.tscn")

func _on_play2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
