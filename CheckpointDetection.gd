extends Area2D

func _on_Area2D_body_entered(body):
	Checkpoints.last_position = global_position
	pass # Replace with function body.
