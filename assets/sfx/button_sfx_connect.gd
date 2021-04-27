extends Button

onready var ui_pressed = load("res://assets/sfx/ui_pressed.wav")

func _ready():
	var audio_player = AudioStreamPlayer.new()
	audio_player.set_stream(ui_pressed)
	self.add_child(audio_player)
	var _ret = self.connect("button_down", audio_player, "play")
