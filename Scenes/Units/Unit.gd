class_name Unit
extends StaticBody2D

# Speed of the spaceship movement in units per second.
var speed = 50
var hp = 100
var direction = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initial setup can be done here.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta * direction.x
	position.y -= speed * delta * direction.y


func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()

func die():
	#print(name, " : Ouch...")
	queue_free()  # For now, just remove the enemy from the scene.
