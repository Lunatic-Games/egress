extends Button


export (bool) var arrow_char = true

func _on_mouse_entered():
	if arrow_char and not text.begins_with(">"):
		text = ">" + text


func _on_mouse_exited():
	if arrow_char and text.begins_with(">"):
		text = text.lstrip(">")


func _on_focus_entered():
	_on_mouse_entered()


func _on_focus_exited():
	_on_mouse_exited()
