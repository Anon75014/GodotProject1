class_name MapGenerator
extends Node

const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const MAP_DEPTH := 15
const MAP_WIDTH := 7
const PATHS := 6
const ENNEMY_WEIGHT := 10
const NEUTRAL_WEIGHT := 6.5

var random_system_type_weights = {
	System.Type.ENNEMY: 0.0,
	System.Type.NEUTRAL: 0.0
}

var random_system_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in MAP_DEPTH - 1:
			current_j = _setup_connection(i, current_j)
			
	_setup_boss_system()
	_setup_random_system_weights()
	_setup_system_types()
	
	var i := 0	
	for row in map_data:
		print("row %s" % i)
		var used_systems = row.filter(
			func(system: System): return system.next_systems.size() > 0
		)
		print(used_systems)
		i+=1
	
	return []

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	for i in MAP_DEPTH:
		var adjacent_systems: Array[System] = []
		for j in MAP_WIDTH:
			var current_system := System.new()
			var offset := Vector2(randf(), randf() * PLACEMENT_RANDOMNESS)
			current_system.position = Vector2(j*X_DIST, i*-Y_DIST) + offset
			current_system.row = i
			current_system.column = j
			current_system.next_systems = []
			
			# Boss room
			if i == MAP_DEPTH-1:
				current_system.position.y = (i+1)*-Y_DIST
			
			adjacent_systems.append(current_system)
		result.append(adjacent_systems)
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH-1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
			
	return y_coordinates
	
func _setup_connection(i: int, j: int) -> int:
	var next_system: System
	var current_system := map_data[i][j] as System
		
	while not next_system or _would_cross_existing_path(i, j, next_system):
		var random_j := clampi(randi_range(j-1, j+1), 0, MAP_WIDTH-1)
		next_system = map_data[i+1][random_j]
	current_system.next_systems.append(next_system)
	return next_system.column
	
func _would_cross_existing_path(i: int, j:int, system:System) -> bool:
	var left_neighbour: System
	var right_neighbour: System
	
	if j>0:
		left_neighbour = map_data[i][j-1]
	if j<MAP_WIDTH-1:
		right_neighbour = map_data[i][j+1]
		
	if right_neighbour and system.column>j:
		for next_system: System in right_neighbour.next_systems:
			if next_system.column < system.column:
				return true
				
	if left_neighbour and system.column > system.column:
		for next_system: System in left_neighbour.next_systems:
			if next_system.column > system.column:
				return true
	return false
	
func _setup_boss_system() -> void:
	var middle := floori(MAP_WIDTH*0.5)
	var boss_system := map_data[MAP_DEPTH-1][middle] as System
	
	for j in MAP_WIDTH:
		var current_system = map_data[MAP_DEPTH-2][j] as System
		if current_system.next_systems:
			current_system.next_systems = [] as Array[System]
			current_system.next_systems.append(boss_system)
	
	boss_system.type = System.Type.BOSS
	
func _setup_random_system_weights() -> void:
	random_system_type_weights[System.Type.ENNEMY] = ENNEMY_WEIGHT
	random_system_type_weights[System.Type.NEUTRAL] = ENNEMY_WEIGHT+NEUTRAL_WEIGHT
	random_system_type_total_weight = random_system_type_weights[System.Type.NEUTRAL]

func _setup_system_types() -> void:
	# first system is always ennemy
	for system: System in map_data[0]:
		if system.next_systems.size() > 0:
			system.type = System.Type.ENNEMY
			
	# Neutral before boss:
	for system: System in map_data[MAP_DEPTH-2]:
		if system.next_systems.size() > 0:
			system.type = System.Type.NEUTRAL
	
	# rest of rooms
	for current_system in map_data:
		for system: System in current_system:
			for next_system: System in system.next_systems:
				if next_system.type == System.Type.NOT_ASSIGNED:
					_set_system_randomly(next_system)

func _set_system_randomly(system_to_set: System) -> void:
	var consecutive_neutral := true
	var neutral_on_13 := true
	var type_candidate: System.Type
	
	while consecutive_neutral or neutral_on_13:
		type_candidate = _get_random_system_type_by_weight()
		var is_neutral := type_candidate == System.Type.NEUTRAL
		var has_neutral_parent := _system_has_parent_of_type(system_to_set, System.Type.NEUTRAL)
		
		consecutive_neutral = is_neutral and has_neutral_parent
		neutral_on_13 = is_neutral and system_to_set.row == 12
	
	system_to_set.type = type_candidate

func _system_has_parent_of_type(system: System, type: System.Type) -> bool:
	var parents: Array[System] = []
	# left parent
	if system.column > 0 and system.row > 0:
		var parent_candidate := map_data[system.row-1][system.column-1] as System
		if parent_candidate.next_systems.has(system):
			parents.append(parent_candidate)
	# parent below
	if system.row > 0:
		var parent_candidate := map_data[system.row-1][system.column] as System
		if parent_candidate.next_systems.has(system):
			parents.append(parent_candidate)
	#right parent
	if system.column > MAP_WIDTH-1 and system.row > 0:
		var parent_candidate := map_data[system.row-1][system.column+1] as System
		if parent_candidate.next_systems.has(system):
			parents.append(parent_candidate)
	
	for parent: System in parents:
		if parent.type == type:
			return true
	return false
	
func _get_random_system_type_by_weight() -> System.Type:
	var roll := randf_range(0.0, random_system_type_total_weight)
	
	for type: System.Type in random_system_type_weights:
		if random_system_type_weights[type] > roll:
			return type
	
	return System.Type.ENNEMY
