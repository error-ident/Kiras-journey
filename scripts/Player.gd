extends KinematicBody2D

var speed = 200
var velocity = Vector2.ZERO
var fall = Vector2(0, -100)
const GRAVITY = 500
const JUMP_SPEED = -300
const MOVE_SPEED = 200
var targets = []

export(int) var hp_max: int = 100
export(int) var hp: int = hp_max

enum {
	IDLE,
	ATTACK,
}
# отключить по дефолту
onready var attack_hand = $attack_range/attack
onready var attack_timer = $attack
onready var hp_bar = $HP_BAR

var direction = "right"
func _ready():
	attack_hand.disabled = true
	attack_timer.set_wait_time(0.1)
	hp_bar.text = "satiety: " + str(hp)

func die(reason):
	# здесь будет переход на другую сцену с экраном "смерти"
	# думаю будет забавно написать причину "смерти"
	print(reason)
	get_tree().reload_current_scene()
	


func _physics_process(delta):
	#hp_bar.text = "satiety: " + str(hp)
	$hp_bar2.value = hp
	var move_direction = 0
	#print($VirtualJoystick.angle)
	if Input.is_action_just_pressed("ui_accept"):
		if get_node_or_null('DialogNode') != null: 
			pass
	# атака
	if Input.is_action_just_pressed("attack"):
		attack_hand.disabled = false
		attack_timer.start()
	# передвижение
	if Input.is_action_pressed("left"):
		if direction == "right":
			direction = "left"
			get_node(".").scale.x *= -1
		move_direction -= 1
	if Input.is_action_pressed("right"):
		if direction == "left":
			direction = "right"
			get_node(".").scale.x *= -1
		move_direction += 1
	velocity.x = move_direction * MOVE_SPEED
	# проверяет что Player находится на полу
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_SPEED
		else:
			velocity.y = 0
	else:
		velocity.y += GRAVITY * delta

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_dead_zone_body_entered(body):
	if body.name == "Player":
		die("шипы оказались колючими")

func _on_attack_timeout():
	attack_hand.disabled = true
	
func get_damage(damage):
	hp -= damage
	if hp <= 0:
		die("Закусана")
	hp_bar.text = "satiety: " + str(hp)
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_weapon"):
		print("получен урон!")
		get_damage(10)

func get_food():
	pass
	
	
