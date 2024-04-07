extends CanvasLayer

@onready var allies: SpinBox = $"VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/AlliesSpinBox"
@onready var ennemies: SpinBox = $"VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/EnnemiesSpinBox"
@onready var play: Button = $"BoxContainer/VBoxContainer/HBoxContainer/PlayButton"
@onready var back: Button = $"BoxContainer/VBoxContainer/HBoxContainer2/BackButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	allies.get_line_edit().grab_focus()
	
	allies.get_line_edit().focus_previous = back.get_path()
	allies.get_line_edit().focus_next = ennemies.get_line_edit().get_path()
	
	ennemies.get_line_edit().focus_previous = allies.get_line_edit().get_path()
	ennemies.get_line_edit().focus_next = play.get_path()
	
	play.focus_previous = ennemies.get_line_edit().get_path()
	back.focus_next = allies.get_line_edit().get_path()


func _on_play_button_pressed():
	var alliesVal = allies.value
	var ennemiesVal = ennemies.value
	print("alliesVal : ", alliesVal, " -- ennemiesVal : ", ennemiesVal)
	
	#Globals.simulationAllies = alliesVal
	#Globals.simulationEnemies = ennemiesVal
	#get_tree().change_scene_to_file("res://Scenes/Maps/Fight_node_2.tscn")

	var fightScene = preload("res://Scenes/Maps/Fight_node_2.tscn").instantiate()
	fightScene.setup(get_tree().root, alliesVal, ennemiesVal)
	get_tree().root.add_child(fightScene)
	get_tree().root.remove_child(self)
	queue_free()
	
	#print(get_tree().root.get_screen_center_position())


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")


# Processes keyboard events
func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")
		queue_free()
