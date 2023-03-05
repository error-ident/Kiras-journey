extends Control

var scene_path_to_load

var test = preload("res://Menu/video.webm")

func _ready():
	print($VideoPlayer.stream.resource_name)
	set_process(true)
	
	$"main/Start Game".grab_focus()
	for button in $main.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])


func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$UISound.play()
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/level_1.tscn")

func _process(_delta):
	pass
		
func _on_VideoPlayer_finished():
	$VideoPlayer.play()
