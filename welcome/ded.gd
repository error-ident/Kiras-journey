extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_NPC_body_entered')
	connect("body_exited", self, '_on_NPC_body_exited')
	
	
func _input(event):
	if get_node_or_null('DialogNode') == null:
		if event.is_action_pressed("ui_accept") and active:
			get_tree().paused = true
			var dialog = Dialogic.start('hello')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self, 'unpause')
			add_child(dialog)
			

func _on_NPC_body_entered(body):
	if body.name == "Player":
		active = true
	
func _on_NPC_body_exited(body):
	if body.name == "Player":
		active = false
		
func unpause(timeline_end):
	get_tree().paused = false
	$"../chest/Sprite".visible = true
	$"../Portal".visible = true
	$"../Portal/AnimationPlayer".play("visible")
	#$AnimationPlayer.play("visible")
	$"../Portal/Area2D/CollisionShape2D".disabled = false
