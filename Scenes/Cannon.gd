extends Node2D
@export var missile: PackedScene = null
var target: Node2D = null
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer

func _ready():
	await get_tree().process_frame
	print($RayCast2D)  # Check if this prints an error
	print($RayCast2D/ReloadTimer)  # Check if this prints an error
	target = find_target()
	
func _physics_process(_delta):
	if target != null:
		# Assuming 'target' has a 'velocity' property that is a Vector2.
		# If 'speed' is just a scalar value, replace 'target.velocity' with 'Vector2(0, target.speed)'
		var prediction_time := 0.5 # Adjust this as necessary
		# Calculate the predicted vertical movement as a Vector2.
		# Assuming downward movement, hence Vector2(0, speed).
		var predicted_movement: Vector2 = Vector2(0, target.speed * prediction_time)

		# Calculate the predicted position by adding the current position to the predicted movement.
		var predicted_position: Vector2 = target.global_position + predicted_movement

		# Now aim the raycast at the predicted position instead of the current position
		var angle_to_target: float = global_position.direction_to(predicted_position).angle()
		rayCast.global_rotation = angle_to_target
		
		if reloadTimer.is_stopped():
			shoot()
	else:
		print("target is null")

func shoot():
	print("PEW")
	rayCast.enabled = false
	
	if missile:
		var missile_instance: Node2D = missile.instantiate()
		if missile_instance:
			print("Missile instance")
			get_tree().root.add_child(missile_instance)
			missile_instance.global_position = global_position
			missile_instance.global_rotation = rayCast.global_rotation
		else:
			print("Missile instance is null. Is the PackedScene loaded correctly?")
		
	reloadTimer.start()

func find_target():
	var new_target: Node2D = null
	print("finding target")
	
	if get_tree().has_group("EnnemyUnits"):
		new_target = get_tree().get_nodes_in_group("EnnemyUnits")[0]
		print("found target")
	
	return new_target

func _on_ReloadTimer_timeout():
	rayCast.enabled = true
