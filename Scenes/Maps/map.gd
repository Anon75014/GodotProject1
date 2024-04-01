class_name Map
extends Node2D

const SCROLL_SPEED := 15
const MAP_SYSTEM = preload("res://Scenes/Maps/map_system.tscn")
const MAP_LINE = preload("res://Scenes/Maps/map_line.tscn")

@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var systems: Node2D = %Systems
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var systems_explored: int
var last_system: System
var camera_edge_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.MAP_DEPTH-1)
	
	generate_new_map()
	unlock_row(0)

# Processes keyboard events
func _input(event: InputEvent) -> void:
	#camera
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)
	
	#going back
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://Scenes/Menus/start_screen.tscn")

func generate_new_map() -> void:
	systems_explored = 0
	map_data = map_generator.generate_map()
	create_map()

func create_map() -> void:
	for current_system: Array in map_data:
		for system: System in current_system:
			if system.next_systems.size() > 0:
				_spawn_system(system)
 # Boss room
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_system(map_data[MapGenerator.MAP_DEPTH-1][middle])
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH-1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2

func unlock_row(which_row: int = systems_explored) -> void:
	for map_system: MapSystem in systems.get_children():
		if map_system.system.row == which_row:
			map_system.available = true

func unlock_next_systems() -> void:
	for map_system: MapSystem in systems.get_children():
		if last_system.next_systems.has(map_system.system):
			map_system.available = true

func show_map() -> void:
	show()
	camera_2d.enabled = true

func hide_map() -> void:
	hide()
	camera_2d.enabled = false
	
func _spawn_system(system: System) -> void:
	var new_map_system := MAP_SYSTEM.instantiate() as MapSystem
	systems.add_child(new_map_system)
	new_map_system.system = system
	new_map_system.selected.connect(_on_map_system_selected)
	_connect_lines(system)
	
	if system.selected and system.row < systems_explored:
		new_map_system.show_selected()
		
func _connect_lines(system: System) -> void:
	if system.next_systems.is_empty():
		return
	
	for next: System in system.next_systems:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(system.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)
		
func _on_map_system_selected(system: System) -> void:
	for map_system: MapSystem in systems.get_children():
		if map_system.system.row == system.row:
			map_system.available = false
	last_system = system
	systems_explored += 1
	#Events.map_exited.emit(system)
