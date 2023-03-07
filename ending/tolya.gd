extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_NPC_body_entered')
	connect("body_exited", self, '_on_NPC_body_exited')
	
	
func _input(event):
	if get_node_or_null('DialogNode') == null:
		if event.is_action_pressed("ui_accept") and active:
			get_tree().paused = true
			var dialog = Dialogic.start('anatoly')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			add_child(dialog)
			dialog.connect('timeline_end', self, 'unpause')
			#remove_child(dialog)
			#remove_child(dialog)
			remove_child($CollisionShape2D)

func _on_NPC_body_entered(body):
	if body.name == "Player":
		active = true
	
func _on_NPC_body_exited(body):
	if body.name == "Player":
		active = false
		
func unpause(timeline_end):
	get_tree().paused = false
