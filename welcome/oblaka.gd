extends ParallaxLayer

export(float) var cloud_speed = -15.0

func _process(delta) -> void:
	self.motion_offset.x +=  cloud_speed * delta
