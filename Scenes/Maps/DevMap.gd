extends CanvasLayer

@onready var playBox: BoxContainer = $"BoxContainer"
@onready var play: Button = $"HBoxContainer/HBoxContainer/PlayButton"

# Called when the node enters the scene tree for the first time.
func _ready():
	play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	var fightScene = preload("res://Scenes/Maps/Fight_node_2.tscn").instantiate()
	
	#fightScene.setup(play, 12, 12)
	fightScene.setup(playBox, randi_range(0, 50), randi_range(0, 50))
	
	for node in playBox.get_children():
		playBox.remove_child(node)
	
	playBox.add_child(fightScene)


func _on_back_button_pressed():
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")
