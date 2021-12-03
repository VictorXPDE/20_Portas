extends KinematicBody2D

onready var timer = $ResetTimer
onready var reset_position = global_position

var velocity = Vector2()
var gravity = 300
var is_triggered = false

export var reset_time : float = 10.0
func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	velocity.y += gravity * delta
	position += velocity * delta
	pass
	
func collide_with(collision : KinematicCollision2D, collider : KinematicBody2D):
	if not is_triggered:
		is_triggered = true
		velocity = Vector2.ZERO
		set_physics_process(true)
		timer.start(reset_time)
	pass
func _on_ResetTimer_timeout():
	set_physics_process(false)
	yield(get_tree(), "physics_frame")
	var temp = collision_layer
	collision_layer = 0
	global_position = reset_position
	yield(get_tree(), "physics_frame")
	collision_layer = temp
	is_triggered = false
	pass # Replace with function body.
