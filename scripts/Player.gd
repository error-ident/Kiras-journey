extends KinematicBody2D

var speed = 200
var velocity = Vector2.ZERO
var fall = Vector2(0, -100)
const GRAVITY = 500
const JUMP_SPEED = -300
const MOVE_SPEED = 200
var targets = []

#export(int) var hp_max: int = 100
#var hp  = Global.hp

enum {
	IDLE,
	ATTACK,
	WALK,
	JUMP,
}
var state = IDLE
var money = 0
# отключить по дефолту
onready var attack_hand = $attack_range/attack
onready var attack_timer = $attack_timer
onready var hp_bar = $money

var direction = "right"
func _ready():
	attack_hand.disabled = true
	attack_timer.set_wait_time(0.1)
	hp_bar.text = "денег: " + str(money)

func die(reason):
	# здесь будет переход на другую сцену с экраном "смерти"
	# думаю будет забавно написать причину "смерти"
	#print(reason)
	get_tree().change_scene("res://scenes/dead_scene.tscn")

func _physics_process(delta):
	# хп
	$hp_bar2.value = Global.hp
	hp_bar.text = "денег: " + str(Global.money)
	var move_direction = 0
	# машина состояний
	#print("player: "+str(state))
	# проверяет что Player находится на полу
	if is_on_floor():
		#print("on floor")
		if $AnimationPlayer.current_animation == "jump":
			$AnimationPlayer.play("idle")
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_SPEED
			$AnimationPlayer.play("jump")
		else:
			velocity.y = 0
	else:
		velocity.y += GRAVITY * delta
	# атака
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack")
		#$knife.play()
		attack_hand.disabled = false
		attack_timer.start()
	# передвижение
	elif Input.is_action_pressed("left"):
		if direction == "right":
			direction = "left"
			#get_node(".").scale.x *= -1
			$sprite.scale.x *= -1
			$attack_range.scale.x *= -1
			$Hitbox.scale.x *= -1
			$CollisionShape2D.scale.x *= -1
		move_direction -= 1
		if !$AnimationPlayer.current_animation == "jump" and !$AnimationPlayer.current_animation == "attack":
			$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("right"):
		if direction == "left":
			direction = "right"
			$sprite.scale.x *= -1
			$attack_range.scale.x *= -1
			$Hitbox.scale.x *= -1
			$CollisionShape2D.scale.x *= -1
		move_direction += 1
		if !$AnimationPlayer.current_animation == "jump" and !$AnimationPlayer.current_animation == "attack":
			$AnimationPlayer.play("walk")
	# не двигается
	else:
		if !$AnimationPlayer.current_animation == "jump" and !$AnimationPlayer.current_animation == "attack":
			$AnimationPlayer.play("idle")
		
	#state = IDLE
	#print(Input.is_pressed())
	velocity.x = move_direction * MOVE_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
#


func _on_dead_zone_body_entered(body):
	if body.name == "Player":
		die("шипы оказались колючими")

func _on_attack_timeout():
	attack_hand.disabled = true
	
func get_damage(damage):
	Global.hp -= damage
	if Global.hp <= 0:
		die("Закусана")
	#hp_bar.text = "satiety: " + str(hp)
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_weapon"):
		print("получен урон!")
		get_damage(10)

func get_food():
	pass
