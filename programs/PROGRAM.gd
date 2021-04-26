extends Resource


class_name program


# Vars for generating the program
export (String) var name
export (bool) var trap = false
export (int) var integrity
export (int) var max_integrity
export (float) var attack_rate
export (int) var attack_value
export (int) var recharge_rate
export (String) var type = "neutral"
export (Color) var color
var host_file

func get(prop):
	var ref = {
		"integrity": integrity,
		"attack_rate": attack_rate,
		"attack_value": attack_value,
		"recharge_rate": recharge_rate
	}
	return ref[prop]

func set(prop, value):
	if (prop == "integrity"):
		integrity = value
	elif (prop == "attack_rate"):
		attack_rate = value
	elif (prop == "attack_value"):
		attack_value = value
	elif (prop == "recharge_rate"):
		recharge_rate = value

func total():
	return integrity + attack_rate + attack_value + recharge_rate
var bits
