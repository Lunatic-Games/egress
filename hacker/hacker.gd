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
onready var total_points = 0
onready var bits_per_point = 100
onready var bits_segment = 0


signal gained_point

func gain_bits(bits):
	self.bits += bits
	self.bits_segment += bits
	set_points()


func gain_trace(trace):
	self.trace += trace
	print("Trace at ", self.trace, "%")
	if (self.trace >= max_trace):
		print("GAME OVER")


func set_points():
	while(bits_segment >= 100):
		total_points += 1
		bits_segment -= 100
		emit_signal("gained_point")


func weak_against(type):
	return weak_against[type]

func strong_against(type):
	return strong_against[type]
