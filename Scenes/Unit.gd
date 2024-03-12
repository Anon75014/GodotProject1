extends Area2D

# Speed of the spaceship movement in units per second.
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initial setup can be done here.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta

