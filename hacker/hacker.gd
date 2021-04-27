extends Node


onready var weak_against = {
	"breaker": "hybrid",
	"wall": "breaker",
	"hybrid": "wall"
}

onready var strong_against = {
	"breaker": "wall",
	"wall": "hybrid",
	"hybrid": "breaker",
	"neutral": "none"
}

onready var trace = 0.0
onready var max_trace = 100.0
onready var bits = 0
onready var total_points = 10
onready var bits_per_point = 100
onready var bits_segment = 0


signal gained_point

func gain_bits(bits):
	self.bits += bits
	self.bits_segment += bits
	set_points()


func gain_trace(trace):
	self.trace += trace
	var ingress_label = get_tree().get_nodes_in_group("ingress_window_title")[0]
	ingress_label.text = "ingress_tracker.vis - trace " + str(int(trace)) + "%"
	if (self.trace >= max_trace):
		lose_game()


func set_points():
	while(bits_segment >= bits_per_point):
		total_points += 1
		bits_segment -= bits_per_point
		emit_signal("gained_point")


func weak_against(type):
	return weak_against[type]

func strong_against(type):
	return strong_against[type]


func win_game():
	# Toggle visible
	var overlay = get_tree().get_nodes_in_group("win")[0]
	overlay.visible = true
	get_tree().paused = true

func lose_game():
	# Toggle Visible
	var overlay = get_tree().get_nodes_in_group("lose")[0]
	overlay.visible = true
	get_tree().paused = true
