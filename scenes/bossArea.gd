extends Area2D

var active = false


func _ready():
	connect("body_entered", self, '_on_NPC_body_entered')
	connect("body_exited", self, '_on_NPC_body_exited')
	

func _on_NPC_body_entered(body):
	if body.name == "Player":
		active = true
		if get_node_or_null('DialogNode') == null:
			get_tree().paused = true
			var dialog = Dialogic.start('crypto')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			add_child(dialog)
			dialog.connect('timeline_end', self, 'unpause')
			#ПОСЛЕ ДИАЛОГА НАДО УДАЛИТЬ/вырубить BOSSAREA и попиздиться с боссом
			#Запустить песню для боссфайта
	
	
func _on_NPC_body_exited(body):
	if body.name == "Player":
		active = false
		
func unpause(timeline_end):
	get_tree().paused = false

	
	
