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


func gain_bits(bits):
	self.bits += bits


func gain_trace(trace):
	self.trace += trace
	print("Trace at ", self.trace, "%")
	if (self.trace >= max_trace):
		print("GAME OVER")


func weak_against(type):
	return weak_against[type]

func strong_against(type):
	return strong_against[type]
