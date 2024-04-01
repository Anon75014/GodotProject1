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

func _ready() -> void:
	var test_system := System.new()
	test_system.type = System.Type.NEUTRAL
	test_system.position = Vector2(100,100)
	system = test_system
	
	await get_tree().create_timer(3).timeout
	available = true

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

func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	system.selected = true
	animation_player.play("Select")
	
func _on_map_system_selected() -> void:
	selected.emit(system)
