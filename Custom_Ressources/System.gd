class_name System
extends Resource

enum Type {NOT_ASSIGNED, ENNEMY, NEUTRAL, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_systems: Array[System]
@export var selected := false

func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
