extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit").grab_focus()
