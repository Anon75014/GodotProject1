extends Node2D

@export var missile_scene:PackedScene

func _input(event):
		var missile = missile_scene.instantiate() as Area2D
		missile.global_position = get_parent().global_position
		#get_tree().root.print_tree()
		get_tree().root.get_node("main").add_child(missile)


