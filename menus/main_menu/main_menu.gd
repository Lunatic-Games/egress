extends Control



func _ready():
	$MarginContainer/VBoxContainer/Buttons/BeginButton.grab_focus()


func _on_BeginButton_pressed():
	pass # Replace with function body.


func _on_SettingsButton_pressed():
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()
