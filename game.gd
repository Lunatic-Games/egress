extends Node2D

onready var main_menu = load("res://menus/main_menu/main_menu.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.popup_centered()
		get_tree().set_input_as_handled()


func _on_MenuButton_pressed():
	get_tree().paused = false
	var scene = get_tree().change_scene_to(main_menu)
