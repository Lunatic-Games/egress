extends Node


onready var weak_against = {
	"breaker": "hybrid",
	"wall": "breaker",
	"hybrid": "wall"
}

onready var strong_against = {
	"breaker": "hybrid",
	"wall": "breaker",
	"hybrid": "wall"
}

onready var trace = 0
onready var max_trace = 100
onready var bits = 0


func gain_bits(bits):
	self.bits += bits


func gain_trace(trace):
	self.trace += trace
	if (trace >= max_trace):
		print("GAME OVER")


func weak_against(type):
	return weak_against[type]

func strong_against(type):
	return strong_against[type]
