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
export (int) var integrity_points
export (int) var max_integrity_points
export (float) var attack_rate_points
export (int) var attack_value_points
export (int) var recharge_rate_points
export (String) var type = "neutral"
export (Color) var color
var host_file
var bits

func get(prop):
	var ref = {
		"integrity": integrity_points,
		"attack_rate": attack_rate_points,
		"attack_value": attack_value_points,
		"recharge_rate": recharge_rate_points
	}
	return ref[prop]

func init_stat_points():
	set("integrity", 0)
	set("attack_rate", 0)
	set("attack_value", 0)
	set("recharge_rate", 0)

func set(prop, value):
	if (prop == "integrity"):
		integrity_points = value
		max_integrity_points = value
		var q = (5*value) + 10
		integrity = q
		max_integrity = q
	elif (prop == "attack_rate"):
		attack_rate_points = value
		attack_rate = 3 - (value/4)
	elif (prop == "attack_value"):
		attack_value_points = value
		attack_value = (3*value) + 3
	elif (prop == "recharge_rate"):
		recharge_rate_points = value
		recharge_rate = 7 - (value/2)

func total():
	return integrity + attack_rate + attack_value + recharge_rate
