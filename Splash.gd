extends Node2D
	
func transition():
	$CanvasLayer/AnimationPlayer.play("fade")

func _on_Timer_timeout():
	get_tree().change_scene("res://Titlescreen.tscn")
	pass # Replace with function body.


func _on_Timer2_timeout():
	transition()
	pass # Replace with function body.
