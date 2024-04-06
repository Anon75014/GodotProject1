extends CanvasLayer

@onready var allies = $"VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/AlliesSpinBox"
@onready var ennemies = $"VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/EnnemiesSpinBox"

# Called when the node enters the scene tree for the first time.
func _ready():
	allies.get_line_edit().grab_focus()


func _on_play_button_pressed():
	var alliesVal = allies.value
	var ennemiesVal = ennemies.value
	print("alliesVal : ", alliesVal, " -- ennemiesVal : ", ennemiesVal)
	
	#Globals.simulationAllies = alliesVal
	#Globals.simulationEnemies = ennemiesVal
	#get_tree().change_scene_to_file("res://Scenes/Maps/Fight_node_2.tscn")

	var fightScene = preload("res://Scenes/Maps/Fight_node_2.tscn").instantiate()
	fightScene.setup(alliesVal, ennemiesVal)
	get_tree().root.add_child(fightScene)
	get_tree().root.remove_child(self)
	
	#print(get_tree().root.get_screen_center_position())


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")


# Processes keyboard events
func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")

