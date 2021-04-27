extends Button


export (bool) var arrow_char = true

onready var ui_pressed = load("res://assets/sfx/ui_pressed.wav")

func _ready():
	var audio_player = AudioStreamPlayer.new()
	audio_player.set_stream(ui_pressed)
	self.add_child(audio_player)
	var _ret = self.connect("button_down", audio_player, "play")

func _on_mouse_entered():
	if arrow_char and not text.begins_with(">") and not disabled:
		text = ">" + text


func _on_mouse_exited():
	if arrow_char and not disabled:
		remove_arrow()

func remove_arrow():
	if text.begins_with(">"):
		text = text.lstrip(">")

func _on_focus_entered():
	_on_mouse_entered()


func _on_focus_exited():
	_on_mouse_exited()
