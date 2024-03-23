extends Area2D

const RIGHT = Vector2.RIGHT
var SPEED = 200


func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("EnnemyUnits"):
		destroy()

func _on_visible_on_screen_notifier_2d_screen_entered():
	pass # Replace with function body.
