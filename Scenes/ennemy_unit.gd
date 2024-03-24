extends StaticBody2D

# Ennemy characteristics
var speed = 50
var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initial setup can be done here.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	
func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()  # For now, just remove the enemy from the scene.
