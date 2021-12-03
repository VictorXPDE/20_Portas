extends Node2D

var pressed = false
func _ready():
	$Cakeicon/AnimationPlayer.play("move")
	$Win.play()
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and pressed == false:
		get_tree().change_scene("res://Titlescreen.tscn")
		pressed = true
