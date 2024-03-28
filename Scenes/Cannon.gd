extends Node2D
@export var missile: PackedScene = null
var target: Node2D = null
var angle_for_shooting: float = 0
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer

func _ready():
	await get_tree().process_frame
	target = find_target()
	
func _physics_process(_delta):
	if target == null or not target.is_inside_tree():
		target = find_target()
	if target != null:
		var prediction_time := 0.5
		# Calculate the predicted vertical movement as a Vector2.
		# Assuming downward movement, hence Vector2(0, speed).
		var predicted_movement: Vector2 = Vector2(0, target.speed * prediction_time)
		# Calculate the predicted position by adding the current position to the predicted movement.
		var predicted_position: Vector2 = target.global_position + predicted_movement
		# Aim the raycast at the ennemy position for detection
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		rayCast.rotation = angle_to_target
		# But aim the missile at the predicted position instead of the current position
		angle_for_shooting = global_position.direction_to(predicted_position).angle()
		
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("EnnemyUnits"):
			if reloadTimer.is_stopped():
				shoot()

func shoot():
	print("PEW")
	rayCast.enabled = false
	
	if missile:
		var missile_instance: Node2D = missile.instantiate()
		if missile_instance:
			get_tree().root.add_child(missile_instance)
			missile_instance.global_position = global_position
			missile_instance.global_rotation = angle_for_shooting
	reloadTimer.start()

func find_target() -> Node2D:
	var closest_target: Node2D = null
	var closest_distance: float = INF  # Set to infinity initially

	for enemy in get_tree().get_nodes_in_group("EnnemyUnits"):
		var distance_to_enemy = global_position.distance_to(enemy.global_position)
		if distance_to_enemy < closest_distance:
			closest_distance = distance_to_enemy
			closest_target = enemy

	if closest_target:
		print("Closest target found")
	
	return closest_target

func _on_ReloadTimer_timeout():
	rayCast.enabled = true
