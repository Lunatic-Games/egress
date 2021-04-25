extends ColorRect

export (Array, Resource) var attackers = []
export (Array, Resource) var defenders = []
export (float) var hacker_dmg_reduction = 10


var defender_stats = {}
var attacker_stats = {}


onready var current_attacker
onready var current_defender
onready var hack_underway = false
onready var defender_index = 0
onready var attacker_index = 0

onready var attacker_bullets = preload("res://assets/particles/attacker_particles.tscn")
onready var defender_bullets = preload("res://assets/particles/defender_particles.tscn")


signal decrypted


func _process(delta):
	
	# If an attacker is present, but none are assigned
	if (attackers.size() > 0 && current_attacker == null):
		# Assign an attacker
		instance_attacker(attackers.pop_front())
	
	# If a defender is present, but not assigned
	if (defenders.size() > 0 && current_defender == null):
		# Assign a defender
		instance_defender(defenders.pop_front())


func break_defender():
	defender_index += 1
	
	# Progress to the next defender
	if (defender_index >= defenders.size()):
		pass
	else:
		defender_defeated()
		instance_defender(defenders[defender_index])


func break_attacker():
	attacker_index += 1
	# TODO CLEAR THE DEFENDER
	
	# Progress to the next defender
	if (attacker_index >= attackers.size()):
		pass
	else:
		attacker_defeated()
		instance_attacker(attackers[attacker_index])



# Clear the defenders stats and prepare for the next one
func defender_defeated():
	$Defender.visible = false
	$DefenderAttackTimer.stop()



# Clear the defenders stats and prepare for the next one
func attacker_defeated():
	$Attacker.visible = false
	$AttackerAttackTimer.stop()


func instance_defender(program):
	$Defender/DefenderSprite.visible = true
	$Defender/DefenderSprite.rect_scale = Vector2(1,1)
	$Defender/DefenderSprite.modulate = program.color
	$DefenderAttackTimer.start(program.attack_rate)
	$DefenderAnimator.play('load_program')
	$Defender.visible = true
	
	current_defender = program.duplicate()


func instance_attacker(program):
	$Attacker/AttackerSprite.visible = true
	$Attacker/AttackerSprite.rect_scale = Vector2(1,1)
	$Attacker/AttackerSprite.modulate = program.color
	$Attacker/AttackerName.bbcode_text = "[center][shake]" + String(program.name)
	$AttackerAttackTimer.start(program.attack_rate)
	
	$AttackerAnimator.play('load_program')
	$Attacker.visible = true
	
	current_attacker = program.duplicate()


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
	bullets.amount = current_defender.attack_value
	$Defender.add_child(bullets)
	
	# Wait a given delay 1 second
	yield(get_tree().create_timer(0.45), "timeout")
	
	# Damage the attacker
	if (current_attacker):
		current_attacker.integrity -= current_defender.attack_value
		scale_program(current_attacker, current_attacker.max_integrity, $Attacker/AttackerSprite)


# Attack the current defender
func _on_AttackerAttackTimer_timeout():

	# Spawn bullet generator
	var bullets = attacker_bullets.instance()
	bullets.emitting = true
	bullets.amount = current_attacker.attack_value
	$Attacker.add_child(bullets)
	
	# Wait a given delay 1 second
	yield(get_tree().create_timer(0.45), "timeout")
	
	# Damage the defender after waiting
	if (current_defender):
		current_defender.integrity -= current_attacker.attack_value
		scale_program(current_defender, current_defender.max_integrity, $Defender/DefenderSprite)
	else:
		Hacker.gain_trace(current_attacker.attack_value / hacker_dmg_reduction)


func scale_program(program, max_integrity, visualizer):

	var value = float(program.integrity) / float(max_integrity)
	if (value < 0):
		value = 0
	
	var scaled = Vector2(value, value)
	print("New scale", scaled)
	visualizer.rect_scale = scaled
