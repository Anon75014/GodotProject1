extends Node2D

var teamSize: int = 10
var enemyTeamSize: int = teamSize

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Globals.simulationAllies:
		teamSize = Globals.simulationAllies
	if Globals.simulationEnemies:
		enemyTeamSize = Globals.simulationEnemies
	
	for i in range(teamSize):
		var unit = load("res://Scenes/Units/unit.tscn").instantiate()
		unit.position.x = -500 + i * 50
		unit.position.y = 300
		unit.name = "Unit%s" % (i+1)
		add_child(unit)
	for i in range(enemyTeamSize):
		var unit = load("res://Scenes/Units/enemy_unit.tscn").instantiate()
		unit.position.x = -500 + i * 50 + 100
		unit.position.y = -300
		unit.name = "EnemyUnit%s" % (i+1)
		add_child(unit)
		
	print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Processes keyboard events
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")
