extends KinematicBody2D
const MOVE_SPEED = 2

var velocity = Vector2.ZERO
const gravity = 500
onready var cast = $cast
onready var enem = $"."
var look = 0
var move_direction = 0

func _physics_process(delta):
	move_direction -= 1
	velocity.x = move_direction * MOVE_SPEED
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	print(cast.get_collider())
		
	
