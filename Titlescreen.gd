extends Node2D

var pressed = false
func _ready():
	$CanvasLayer/Titlescreen/CenterContainer/Label/AnimationPlayer.play("move")
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and pressed == false:
		$CanvasLayer/Titlescreen/CenterContainer2/Label2/AnimationPlayer.play("flash")
		$Select.play()
		$Timer.start()
		pressed = true
	elif Input.is_action_just_pressed("ui_cancel") and pressed == false:
		get_tree().quit()


func _on_Timer_timeout():
	$CanvasLayer/Titlescreen/AnimationPlayer2.play("fade")
	$Timer2.start()
	pass # Replace with function body.


func _on_Timer2_timeout():
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.
