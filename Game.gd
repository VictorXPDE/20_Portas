# e esse aki é tudo um monte de if e else pra cada tela

extends Node2D

onready var camera = get_node("Player/Camera2D")
onready var player = get_node("Player")

func _enter_tree():
	if Checkpoints.last_position:
		$Player.global_position = Checkpoints.last_position
	pass
func reset_player_attr(): # Reseta os atributos do jogador para o padrão
	player.jump_strength = 300
	player.speed = 200
	player.can_wall_jump = false
	player.can_infinite_jump = false
	player.can_cancel_jump = true
	player.invert_controllers = false
	player.can_move_vertically = false
	player.gravity_switched = false
	player.grow = false
	player.move_timer_enabled = false
	player.randomize_movement = false
	player.can_jump = true
	player.move_left_only = false
	player.one_way_wall_enabled = false
	player.bounce = false
	player.half_y_scale = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Titlescreen.tscn")
		
	if camera.cur_screen == Vector2(-1,0):
		reset_player_attr()
		stop()
		player.jump_strength = 700
	elif camera.cur_screen == Vector2(-2,0):
		reset_player_attr()
		stop()
		player.speed = 550
	elif camera.cur_screen == Vector2(-2,1):
		reset_player_attr()
		stop()
		player.can_wall_jump = true
	elif camera.cur_screen == Vector2(-3,1):
		reset_player_attr()
		stop()
		player.can_infinite_jump = true
		player.can_cancel_jump = false
	elif camera.cur_screen == Vector2(-3,2):
		reset_player_attr()
		stop()
		player.invert_controllers = true
	elif camera.cur_screen == Vector2(-2,2):
		reset_player_attr()
		stop()
		# A maneira mais eficiente possivel de mexer o jogador
		if not player.is_dead:
			player.global_position += Vector2(3,0)
		player.can_move_vertically = true
		player.move_vertically_constantly = true
		player.gravity_switched = false
		player.jump_strength = 0
	elif camera.cur_screen == Vector2(-1,2):
		reset_player_attr()
		stop()
		player.gravity_switched = true
	elif camera.cur_screen == Vector2(0,2):
		reset_player_attr()
		stop()
		player.grow = true
		player.jump_strength = 500
	elif camera.cur_screen == Vector2(1,2):
		reset_player_attr()
		player.move_timer_enabled = true
		move_timer()
	elif camera.cur_screen == Vector2(2,2):
		reset_player_attr()
		stop()
		player.randomize_movement = true
	elif camera.cur_screen == Vector2(2,3):
		reset_player_attr()
		stop()
		player.can_jump = false
		player.speed = 400
	elif camera.cur_screen == Vector2(1,3):
		reset_player_attr()
		stop()
		player.move_left_only = true
	elif camera.cur_screen == Vector2(0,3):
		reset_player_attr()
		stop()
		$Player/CollisionShape2D.disabled = false
		player.half_y_scale = true
	elif camera.cur_screen == Vector2(-1,3):
		reset_player_attr()
		stop()
		player.jump_strength = 400
	elif camera.cur_screen == Vector2(-1,5):
		reset_player_attr()
		stop()
		player.bounce = true
		player.move_constantly = true
		player.speed = 400
	elif camera.cur_screen == Vector2(0,5):
		reset_player_attr()
		stop()
		player.can_move_vertically = true
		player.can_jump = false
	elif camera.cur_screen == Vector2(2,5):
		reset_player_attr()
		stop()
		player.speed = 130
	elif camera.cur_screen == Vector2(3,5):
		reset_player_attr()
		stop()
		hue()
		player.can_wall_jump = true
		player.jump_strength = 400
		player.bounce = true
		player.can_infinite_jump = true
		player.can_move_vertically = true
		player.move_vertically_constantly = true
		if $VisibleTimer.is_stopped():
			disable()
			$VisibleTimer.start()
	else:
		reset_player_attr()
		stop()
	pass
		
func move_timer():
	if player.move_timer_enabled == true and $MoveTimer.is_stopped():
		$MoveTimer.start()
		if not player.is_dead:
			$Countdown.play()

func stop():
	$MoveTimer.stop()
	$MoveTimer2.stop()
	$Countdown.stop()

func hue():
	$RGBTile/AnimationPlayer.play("hue")
	$RGBTile2/AnimationPlayer.play("hue")
	$RGBTile3/AnimationPlayer.play("hue")
	$RGBTile4/AnimationPlayer.play("hue")
	$RGBTile5/AnimationPlayer.play("hue")
	$RGBSpike/AnimationPlayer.play("hue")
	$RGBSpike2/AnimationPlayer.play("hue")
	$RGBSpike3/AnimationPlayer.play("hue")
	$RGBSpike4/AnimationPlayer.play("hue")
	$RGBBackground/AnimationPlayer.play("hue")

func disable():
	$RGBTile2.set_collision_layer_bit(0, false)
	$RGBTile2.set_collision_mask_bit(0, false)
	$RGBTile2.visible = false
	$RGBTile3.set_collision_layer_bit(0, false)
	$RGBTile3.set_collision_mask_bit(0, false)
	$RGBTile3.visible = false
	$RGBTile4.set_collision_layer_bit(0, false)
	$RGBTile4.set_collision_mask_bit(0, false)
	$RGBTile4.visible = false
	$RGBTile5.set_collision_layer_bit(0, false)
	$RGBTile5.set_collision_mask_bit(0, false)
	$RGBTile5.visible = false
	$RGBSpike.set_collision_layer_bit(0, false)
	$RGBSpike.set_collision_mask_bit(0, false)
	$RGBSpike.visible = false
	$RGBSpike2.set_collision_layer_bit(0, false)
	$RGBSpike2.set_collision_mask_bit(0, false)
	$RGBSpike2.visible = false
	$RGBSpike3.set_collision_layer_bit(0, false)
	$RGBSpike3.set_collision_mask_bit(0, false)
	$RGBSpike3.visible = false
	$RGBSpike4.set_collision_layer_bit(0, false)
	$RGBSpike4.set_collision_mask_bit(0, false)
	$RGBSpike4.visible = false
	
func _on_MoveTimer_timeout():
	player.die_on_moving = true
	player.visible = false
	$MoveTimer2.start()
	pass # Replace with function body.


func _on_MoveTimer2_timeout():
	player.die_on_moving = false
	player.visible = true
	$MoveTimer.start()
	if not player.is_dead:
		$Countdown.play()
	pass # Replace with function body.


func _on_VisibleTimer_timeout():
	disable()
	var tile_enabled = [$RGBTile2, $RGBTile3, $RGBTile4, $RGBTile5]
	var spike_enabled = [$RGBSpike, $RGBSpike2, $RGBSpike3, $RGBSpike4]
	var random = floor(rand_range(0,4))
	tile_enabled[random].set_collision_layer_bit(0, true)
	tile_enabled[random].set_collision_mask_bit(0, true)
	tile_enabled[random].visible = true
	spike_enabled[random].set_collision_layer_bit(0, true)
	spike_enabled[random].set_collision_mask_bit(0, true)
	spike_enabled[random].visible = true
	pass # Replace with function body.
