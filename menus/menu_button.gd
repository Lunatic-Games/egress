extends Button


func _on_mouse_entered():
	if not text.begins_with(">"):
		text = ">" + text


func _on_mouse_exited():
	if text.begins_with(">"):
		text = text.lstrip(">")


func _on_focus_entered():
	_on_mouse_entered()


func _on_focus_exited():
	_on_mouse_exited()
