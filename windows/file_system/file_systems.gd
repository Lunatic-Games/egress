extends ColorRect

onready var depth = 0
onready var directories = get_tree().get_nodes_in_group("directories")


func go_deeper():
	
	directories[depth].visible = false
	depth += 1
	directories[depth].visible = true
