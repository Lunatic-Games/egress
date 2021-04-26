extends Popup


func _unhandled_input(event):
	if visible and event.is_action_pressed("pause"):
		_on_ContinueButton_pressed()
		get_tree().set_input_as_handled()


func _on_ContinueButton_pressed():
	hide()
	get_tree().paused = false


func _on_ExitButton_pressed():
	var _ret = get_tree().change_scene("res://menus/main_menu/main_menu.tscn")
	get_tree().paused = false
