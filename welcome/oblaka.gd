extends ParallaxLayer

export(float) var cloud_speed = -15.0

func _process(delta) -> void:
	self.motion_offset.x +=  cloud_speed * delta


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://scenes/level_1.tscn")
