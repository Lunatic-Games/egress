extends ColorRect

var defender_stats = {}
var attacker_stats = {}


export (Array, Resource) var attackers = []
onready var defenders = []
onready var hack_underway = false
onready var defender_index = 0
onready var attacker_index = 0

onready var attacker_bullets = preload("res://assets/particles/attacker_particles.tscn")
onready var defender_bullets = preload("res://assets/particles/defender_particles.tscn")


signal decrypted


func _process(delta):
	
	# If a hack is happening
	if (hack_underway):
		
		# Check to break a defending program
		if (defenders[defender_index].integrity <= 0):
			break_defender()
		
		# Check to break an attacking program
		if (attackers[attacker_index].integrity <= 0):
			break_attacker()


func begin_hack():
	hack_underway = true
	defender_index = 0
	attacker_index = 0
	
	# If there are no attackers
	if (attackers.size() <= 0):
		hack_failed()
		hack_underway = false
	else:
		# TODO CLEAR THE ATTACKER AND DEFENDER
		instance_attacker(attackers[attacker_index])
		instance_defender(defenders[defender_index])


func break_defender():
	defender_index += 1
	
	# Progress to the next defender
	if (defender_index >= defenders.size()):
		hack_successful(defenders[0].host_file)
	else:
		defender_defeated()
		instance_defender(defenders[defender_index])


func break_attacker():
	attacker_index += 1
	# TODO CLEAR THE DEFENDER
	
	# Progress to the next defender
	if (attacker_index >= attackers.size()):
		hack_failed()
	else:
		attacker_defeated()
		instance_attacker(attackers[attacker_index])


# Signal to the file that the hack was successful
func hack_successful(host_file):
	print("Hacked")
	emit_signal("decrypted", host_file)
	
	$DefenderSprite.visible = false
	$DefenderAttackTimer.stop()
	$AttackerSprite.visible = false
	$AttackerAttackTimer.stop()
	hack_underway = false


# Clear the defenders stats and prepare for the next one
func defender_defeated():
	$DefenderSprite.visible = false
	$DefenderAttackTimer.stop()


# Signal to the file that the hack was successful
func hack_failed():
	print("Hacked")


# Clear the defenders stats and prepare for the next one
func attacker_defeated():
	$AttackerSprite.visible = false
	$AttackerAttackTimer.stop()


func instance_defender(program):
	$DefenderSprite.visible = true
	$DefenderSprite.modulate = program.color
	$DefenderAttackTimer.start(program.attack_rate)


func instance_attacker(program):
	$AttackerSprite.visible = true
	$AttackerSprite.modulate = program.color
	$AttackerAttackTimer.start(program.attack_rate)


func queue_defender(program, id):
	program.host_file = id
	defenders.push_back(program)



func is_free():
	return ! hack_underway


# attack the current attacker
func _on_DefenderAttackTimer_timeout():
	
	# Spawn bullet generator
	var bullets = defender_bullets.instance()
	bullets.emitting = true
	bullets.amount = defenders[defender_index].attack_value
	$DefenderSprite.add_child(bullets)
	
	# Damage the attacker
	attackers[attacker_index].integrity -= defenders[defender_index].attack_value

	# TODO Emit particles

# Attack the current defender
func _on_AttackerAttackTimer_timeout():

	# Spawn bullet generator
	var bullets = attacker_bullets.instance()
	bullets.emitting = true
	bullets.amount = attackers[attacker_index].attack_value
	$AttackerSprite.add_child(bullets)
	
	# Damage the attacker
	defenders[defender_index].integrity -= attackers[attacker_index].attack_value

	# TODO Emit particles
