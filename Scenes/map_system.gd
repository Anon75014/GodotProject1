class_name MapSystem
extends Area2D

signal selected(system: System)

const ICONS := {
	System.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	System.Type.ENNEMY: [preload("res://Assets/ENNEMY.png"), Vector2.ONE],
	System.Type.NEUTRAL: [preload("res://Assets/NEUTRAL.png"), Vector2.ONE],
	System.Type.BOSS: [preload("res://Assets/BOSS.png"), Vector2(1.25,1.25)],
}

@onready var sprite_2d : Sprite2D = $Visuals/Sprite2D
@onready var line_2d : Line2D = $Visuals/Line2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var system: System : set = set_system

func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		animation_player.play("Highlight")
	elif not system.selected:
		animation_player.play("RESET")
		
func set_system(new_data: System) -> void:
	system = new_data
	position = system.position
	line_2d.rotation_degrees = randi_range(0,360)
	sprite_2d.texture = ICONS[system.type][0]
	sprite_2d.scale = ICONS[system.type][1]

func _on_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
