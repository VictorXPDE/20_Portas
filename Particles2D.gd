extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	pass # Replace with function body.


func start():
	emitting = true

func stop():
	emitting = false
