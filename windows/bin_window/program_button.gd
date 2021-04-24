extends Control


func set_appearance(color, text):
	$HBoxContainer/Label.text = text
	$HBoxContainer/CenterContainer/icon.modulate = color
