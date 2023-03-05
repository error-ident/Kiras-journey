extends KinematicBody2D
const MOVE_SPEED = 2
signal get_damage
var velocity = Vector2.ZERO
const gravity = 500
onready var cast = $cast
onready var enem = $"."
onready var area_angry = $area_angry
onready var hp_label = $hp
onready var attack_timer = $attack_timer
onready var attack = $attack_zone
onready var anima = $anima

var hp = 11
var move_direction = 0
var directory = "left"

enum {
	IDLE,
	RUN,
	ATTACK,
	DIE,
}
var state = IDLE
onready var player = $"../Player"

func _physics_process(delta):
	print(state)
	match state:
		IDLE:
			$idle.visible = true
			$run.visible = false
			$attack.visible = false
			$anima.play("idle")
		RUN:
			#print($anima.current_animation)
			if !$anima.current_animation == "attack":
				$anima.play("run")
				$idle.visible = false
				$run.visible = true
				$attack.visible = false
				move_state(delta, player)
		ATTACK:
			$idle.visible = false
			$run.visible = false
			$attack.visible = true
			$anima.play("attack")
			attack_timer.start()
			$attack_zone/Collision.disabled = true
		DIE:
			$idle.visible = true
			$run.visible = false
			$attack.visible = false
			die()

func move_state(delta, player):
	# повернут направо
	if position.direction_to(player.position).x > 0:
		if directory == "left":
			enem.scale.x *= -1
			directory = "right"
		move_direction = 30
	# повернут налево
	else:
		if directory == "right":
			enem.scale.x *= -1
			directory = "left"
		move_direction = -30
	#move_direction += position.direction_to(player.position).x
	velocity.x = move_direction * MOVE_SPEED
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func die():
	remove_child($attack_timer)
	remove_child($area_angry)
	remove_child($dmg_zone)
	remove_child($attack_zone)
	remove_child($col)
	$anima.play("die")
func get_damage():
		hp -= 1
		hp_label.text = str(hp)
		$hp_bar2.value -= 1
		if hp <= 0:
			state = DIE

func _on_area_angry_body_entered(body):
	if body.name == "Player":
		state = RUN

# зона удара игрока по мобу
func _on_dmg_zone_area_entered(area):
	if area.is_in_group("weapon"):
		get_damage()
		print("получен урон (моб крыса): {}")

# игрок в зоне поражения
func _on_attack_zone_body_entered(body):
	if body.is_in_group("player"):
		state = ATTACK
		#body.
		
func _on_attack_zone_body_exited(body):
	print("мачи")
	state = RUN

func _on_attack_timer_timeout():
	if $attack_zone/Collision:
		$attack_zone/Collision.disabled = false
	state = RUN
