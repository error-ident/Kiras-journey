extends KinematicBody2D

var speed = 200
var velocity = Vector2.ZERO
var fall = Vector2(0, -100)
const GRAVITY = 500
const JUMP_SPEED = -300
const MOVE_SPEED = 200

func _ready():
	pass
	
func _physics_process(delta):
	var move_direction = 0
	#print($VirtualJoystick.angle)
	# атака
	if Input.is_action_just_pressed("attack"):
		print("attack!")
	# передвижение
	if Input.is_action_pressed("left"):
		move_direction -= 1
	if Input.is_action_pressed("right"):
		move_direction += 1
	velocity.x = move_direction * MOVE_SPEED
	# проверяет что Player находится на полу
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
		else:
			velocity.y = 0
	else:
		velocity.y += GRAVITY * delta

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_dead_zone_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
