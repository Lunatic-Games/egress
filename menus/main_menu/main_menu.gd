extends Control

onready var terminate_button = $MarginContainer/VBoxContainer/Buttons/TerminateButton
onready var config_button = $MarginContainer/VBoxContainer/Buttons/ConfigButton
onready var config_container = $MarginContainer/VBoxContainer/Buttons/ConfigContainer

onready var exit_fullscreen_button = config_container.get_node("VBoxContainer/ExitFullscreenButton")
onready var fullscreen_button = config_container.get_node("VBoxContainer/FullscreenButton")
onready var volume_label = config_container.get_node("VBoxContainer/VolumeSliderContainer/VolumeLabel")
onready var volume_slider = config_container.get_node("VBoxContainer/VolumeSliderContainer/MarginContainer/VolumeSlider")

func _ready():
	$MarginContainer/VBoxContainer/Buttons/BeginButton.grab_focus()
	volume_slider.value = get_volume_level()


func get_volume_level():
	return db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100.0


func set_volume_level(level):
	var db = linear2db(level / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	

func _on_VolumeSlider_value_changed(value):
	set_volume_level(value)


func _on_BeginButton_pressed():
	pass # Replace with function body.


func _on_ConfigButton_pressed():
	config_container.visible = !config_container.visible
	if config_container.visible:
		if fullscreen_button.visible:
			config_button.focus_neighbour_bottom = fullscreen_button.get_path()
		else:
			config_button.focus_neighbour_bottom = exit_fullscreen_button.get_path()
		terminate_button.focus_neighbour_top = volume_slider.get_path()
	else:
		config_button.focus_neighbour_bottom = terminate_button.get_path()
		terminate_button.focus_neighbour_top = config_button.get_path()


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_FullscreenButton_pressed():
	OS.window_fullscreen = true
	
	var exit_fullscreen_button = config_container.get_node("VBoxContainer/ExitFullscreenButton")
	exit_fullscreen_button.visible = true
	exit_fullscreen_button.grab_focus()
	exit_fullscreen_button.focus_neighbour_top = config_button.get_path()
	config_button.focus_neighbour_bottom = exit_fullscreen_button.get_path()
	
	config_container.get_node("VBoxContainer/FullscreenButton").visible = false


func _on_ExitFullscreenButton_pressed():
	OS.window_fullscreen = false
	
	var fullscreen_button = config_container.get_node("VBoxContainer/FullscreenButton")
	fullscreen_button.visible = true
	fullscreen_button.grab_focus()
	fullscreen_button.focus_neighbour_top = config_button.get_path()
	config_button.focus_neighbour_bottom = fullscreen_button.get_path()
	
	config_container.get_node("VBoxContainer/ExitFullscreenButton").visible = false
	

func _on_VolumeSlider_focus_entered():
	volume_label.pressed = true


func _on_VolumeSlider_focus_exited():
	volume_label.pressed = false
