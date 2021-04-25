extends Sprite


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	global_position = get_viewport().get_mouse_position()
	global_position.x = max(global_position.x, 0.0)
	global_position.y = max(global_position.y, 0.0)
