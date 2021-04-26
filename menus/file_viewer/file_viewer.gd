extends Popup


func _on_CloseButton_pressed():
	visible = false
	get_tree().paused = false

func view(name="", body=""):
	$Background/MarginContainer/VBoxContainer/Title.text = name
	$Background/MarginContainer/VBoxContainer/Body.text = body
	popup_centered()
	get_tree().paused = true
