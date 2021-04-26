extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.popup_centered()
		get_tree().set_input_as_handled()
