extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
var tex_array = [preload("res://sprites/food/sushi.png"), preload("res://sprites/food/pizza.png"), preload("res://sprites/food/hamburger.png")]
onready var player = $"../../Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var random_int = randi()%3
	sprite.texture = tex_array[random_int]
	$anim.play("up_down")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area_body_entered(body):
	if body.name == "Player":
		Global.hp += 10
		if Global.hp > 100:
			Global.hp = 100
		Global.money += 10
		$anim.play("take")
		

