# TODO
# aprender a escrever codigo melhor

# o ngc inteiro é tudo um monte de variavel booleana com if e else
# mas pelo menos funciona

extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

var movement = Vector2.ZERO
var jump_strength = 300
var speed = 200
var gravity = 600

var can_jump = true
var can_wall_jump = false
var can_walk = true
var can_infinite_jump = false
var can_cancel_jump = true
var can_move_vertically = false

var gravity_switched = false
var grow = false
var randomize_movement = false
var random_movement = 0
var move_left_only = false

var jump_count
var move_timer_enabled = true
var invert_controllers = false
var die_on_moving = false
var half_y_scale = false
var one_way_wall_enabled = false
var invisible_tile_enabled = true
var bounce = false
var move_constantly = false
var move_vertically_constantly = false

var is_dead = false
var is_4_direction_movement = false

var wallJump = 400
var jumpWall = 60

onready var _pivot: Node2D = $Player_Sprite
onready var _animation_player: AnimationPlayer = $Player_Sprite/AnimationPlayer
onready var _start_scale: Vector2 = _pivot.scale
onready var _timer: Timer = $Timer
onready var _explosion: Particles2D = $Explosion/Particles2D
onready var _tile = get_node("/root/Game/InvisibleTile")
onready var _spikes = get_node("/root/Game/InvisibleSpikes")

# Called when the node enters the scene tree for the first time.
func _ready():
	_explosion.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead == false:
		if invert_controllers == false:
			var horizontal_direction = (
				Input.get_action_strength("ui_right")
				-Input.get_action_raw_strength("ui_left")
			)
			var horizontal_direction_left_only = (
				-Input.get_action_raw_strength("ui_left")
			)
			if can_walk == true:
				if can_move_vertically == false:
					if randomize_movement == true:
						random_movement = floor(rand_range(0,2))
						if random_movement == 0:
							movement.x = horizontal_direction * 800
						elif random_movement == 1:
							movement.x = horizontal_direction * -500
					else:
						if move_left_only == true:
							movement.x = horizontal_direction_left_only * speed
						else:
							if move_constantly == true:
								if Input.is_action_just_pressed("ui_right"):
									movement.x = speed
								if Input.is_action_just_pressed("ui_left"):
									movement.x = -speed
							else:
								movement.x = horizontal_direction * speed
					if gravity_switched == true:
						movement.y -= gravity * delta
					else:
						movement.y += gravity * delta
				else:
					movement.x = horizontal_direction * speed
					if move_vertically_constantly == true:
						if Input.is_action_pressed("ui_up"):
							movement.y = -speed
						elif Input.is_action_pressed("ui_down"):
							movement.y = speed
					else:
						movement = Vector2.ZERO
						if Input.is_action_pressed("ui_up"):
							movement.y -= speed
						if Input.is_action_pressed("ui_down"):
							movement.y += speed
						movement.x = horizontal_direction * speed
		else:
			var horizontal_direction = (
				-Input.get_action_strength("ui_right")
				+Input.get_action_raw_strength("ui_left")
			)
			if can_walk == true:
				movement.x = horizontal_direction * speed
				if gravity_switched == true:
					movement.y -= gravity * delta
				else:
					movement.y += gravity * delta
			
		var is_falling = movement.y > 0 and not is_on_floor()
		var is_jumping = Input.is_action_just_pressed("jump") and can_jump == true
		var is_holding_jump = Input.is_action_pressed("jump")
		var is_jump_canceled = Input.is_action_just_released("jump") and movement.y < 0
		var is_idling = is_on_floor() and is_zero_approx(movement.x)
		var is_running = is_on_floor() and not is_zero_approx(movement.x)
		var is_idling_up = is_on_ceiling() and is_zero_approx(movement.x)
		var is_running_up = is_on_ceiling() and not is_zero_approx(movement.x)
	
		if is_on_floor() or nextToWall():
			if is_jumping:
				if die_on_moving == true:
					die()
				else:
					movement.y = -jump_strength
					$JumpSound.play()
				if can_walk == true:
					if not is_on_floor() and nextToRightWall():
						movement.x -= wallJump
						movement.y -= jumpWall
						_animation_player.play("Idle")
						can_walk = false
						_timer.start()
					if not is_on_floor() and nextToLeftWall():
						movement.x += wallJump
						movement.y -= jumpWall
						_animation_player.play("Idle")
						can_walk = false
						_timer.start()
			elif is_jump_canceled:
				movement.y = 0
		elif is_jumping and can_infinite_jump == true:
			movement.y = -jump_strength
			$JumpSound.play()
		elif is_jump_canceled and can_cancel_jump == true:
			movement.y = 0
			
		elif is_on_ceiling() and gravity_switched == true:
			rotation_degrees = 180
			if is_jumping:
				$JumpSound.play()
				movement.y = jump_strength
			
			elif is_idling_up:
				_animation_player.play("Idle")
			elif is_running_up:
				_animation_player.play("Running")
				
		var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
		
		if bounce == true:
			var collision_info = move_and_collide(movement * delta)
			
			if collision_info:
				movement = movement.bounce(collision_info.normal)
				if collision_info.collider.is_in_group("kill"):
					die()
		else:
			movement = move_and_slide_with_snap(movement, snap, UP_DIRECTION)
		
		# Virar o jogador de cabeça pra baixo
		if gravity_switched == true:
			rotation_degrees = 180
		else:
			rotation_degrees = 0
			
		if grow == true:
			scale.x += 0.008
			scale.y += 0.008
		else:
			scale.x = 1
			scale.y = 1
			if half_y_scale == true:
				scale.y = 0.5
			else:
				scale.y = 1
			
		if die_on_moving == true and not is_zero_approx(movement.x):
			die()
			
		if is_idling:
			_animation_player.play("Idle")
		elif is_falling:
			_animation_player.play("Idle")
		elif is_running:
			_animation_player.play("Running")
			
		if invisible_tile_enabled == true:
			if is_holding_jump and not is_on_floor():
				_tile.visible = true
				_spikes.visible = true
			else:
				_tile.visible = false
				_spikes.visible = false
			
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("kill"):
				die()
			if collision.collider.has_method("collide_with"):
				collision.collider.collide_with(collision,self)
				
		
		pass
		

func nextToWall():
	if can_wall_jump == true:
		return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()
	
func nextToLeftWall():
	return $LeftWall.is_colliding()
	
func get_pos():
	var position = get_canvas_transform().origin + global_position
	return position
		
func _on_Timer_timeout():
	can_walk = true
	pass # Replace with function body.

func die():
	is_dead = true
	_explosion.start()
	$ExplosionSound.play()
	$CollisionShape2D.disabled = true
	movement = Vector2(0,0)
	$Player_Sprite.visible = false
	$DeathTimer.start()
	pass
		
func _on_DeathTimer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.
