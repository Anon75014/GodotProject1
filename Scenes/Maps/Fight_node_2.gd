extends Node2D

var teamSize: int = 10
var enemyTeamSize: int = teamSize

func setup(alliesVal, ennemiesVal):
	teamSize = alliesVal
	enemyTeamSize = ennemiesVal
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print($"Camera2D".get_screen_center_position())
	print(get_viewport_rect())
	print(get_viewport_rect().get_center())
	print(get_viewport_rect().position)
	print(get_viewport_rect().end)
	
	var TL = get_viewport_rect().position
	var BR = get_viewport_rect().end
	var TR = Vector2(BR.x,TL.y)
	var BL = Vector2(TL.x,BR.y)
	
	print(TL.x, ";", TL.y, " -- ", BR.x, ";", BR.y)
	
	#if Globals.simulationAllies:
		#teamSize = Globals.simulationAllies
	#if Globals.simulationEnemies:
		#enemyTeamSize = Globals.simulationEnemies
	
	var MARGIN = 50
	var t_SPACING = ((BR.x-TL.x) - 2 * MARGIN)/teamSize
	var et_SPACING = ((BR.x-TL.x) - 2 * MARGIN)/enemyTeamSize
	
	for i in range(teamSize):
		var unit = load("res://Scenes/Units/unit.tscn").instantiate()
		unit.position.x = BL.x + 1.5 * MARGIN + i * t_SPACING
		unit.position.y = BL.y + MARGIN
		unit.name = "Unit%s" % (i+1)
		add_child(unit)
	for i in range(enemyTeamSize):
		var unit = load("res://Scenes/Units/enemy_unit.tscn").instantiate()
		unit.position.x = TR.x - MARGIN - i * et_SPACING
		unit.position.y = TR.y - MARGIN
		unit.name = "EnemyUnit%s" % (i+1)
		add_child(unit)
		
	#print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Processes keyboard events
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")
		get_tree().root.remove_child(self)
