extends ColorRect


onready var has_defender = false
onready var attacker
onready var attackers = []

signal decrypted


func instance_program(trap, integrity, attack_rate, attack_value, type, id):
	emit_signal("decrypted", id)



func is_free():
	return ! has_defender
