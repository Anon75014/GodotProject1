extends Area2D
class_name Missile

@export var speed = 200
var direction = Vector2()

func _process(delta):
	position.y -= speed * delta
	position.x -= speed * delta

