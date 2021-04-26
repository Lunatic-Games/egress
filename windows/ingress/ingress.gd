extends ColorRect

export (Array, Resource) var attackers = []
export (Array, Resource) var defenders = []
export (float) var hacker_dmg_reduction = 3.5

var TYPE_MULTIPLIER = 2.5

var defender_stats = {}
var attacker_stats = {}


onready var current_attacker
onready var current_defender
onready var hack_underway = false
onready var defender_index = 0
onready var attacker_index = 0

onready var attack_particle = preload("res://programs/attack_particle/attack_particle.tscn")
onready var distress_particles = preload("res://assets/particles/distress_particles.tscn")


signal decrypted
signal defeated_program(program)


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
	
	# Clear the defender
	defender_defeated()
	
	# Progress to the next defender
	if (defenders.size() > 0):
		instance_defender(defenders.pop_front())


func break_attacker():
	
	# Clear the attacker
	attacker_defeated()
	
	# Progress to the next attacker
	if (attackers.size() > 0):
		instance_attacker(attackers.pop_front())



# Clear the defenders stats and prepare for the next one
func defender_defeated():
	$Attacker.visible = false
	$AttackerAttackTimer.stop()
	emit_signal("defeated_program", current_defender)
	current_defender = null



# Clear the defenders stats and prepare for the next one
func attacker_defeated():
	$Defender.visible = false
	$DefenderAttackTimer.stop()
	current_attacker = null


func instance_defender(program):
	
	# This code has been swapped but not renamed due to time limit
	$AttackerAnimator.play('load_program')
	
	$Attacker/AttackerSprite.rect_scale = Vector2(1,1)
	$Attacker/AttackerSprite.modulate = program.color
	$Attacker/AttackerName.bbcode_text = "[center][shake]" + String(program.name)
	$AttackerAttackTimer.start(program.attack_rate)
	
	$Attacker.visible = true
	$Attacker/AttackerSprite.visible = true
	
	current_defender = program.duplicate()


func instance_attacker(program):
	
	# This code has been swapped but not renamed due to time limit
	$DefenderAnimator.play('load_program')
	$Defender/DefenderSprite.rect_scale = Vector2(1,1)
	$Defender/DefenderSprite.modulate = program.color
	$Defender/DefenderName.bbcode_text = "[center][shake]" + String(program.name)
	$DefenderAttackTimer.start(program.attack_rate)
	$Defender.visible = true
	$Defender/DefenderSprite.visible = true
	
	current_attacker = program.duplicate()



func queue_defender(program, id):
	program.host_file = id
	defenders.push_back(program)



func is_free():
	return ! hack_underway


# attack the current defender
func _on_DefenderAttackTimer_timeout():
	
	if (current_attacker):
		# THIS CODE HAS ALSO BEEN SWAPPED TO DEFENDER DUE TO TIME LIMIT
		# Spawn bullet generator
		spawn_attack_particles(current_attacker.attack_value,
			current_attacker.color, $Defender, $Attacker)
		
		# Calculate the damage to be done
		var damage
		var type_adv = false
		if (current_defender && Hacker.strong_against(current_attacker.type) == current_defender.type):
			damage = current_attacker.attack_value * TYPE_MULTIPLIER
			type_adv = true
		else:
			damage = current_attacker.attack_value
		# Wait a given delay 1 second
		yield(get_tree().create_timer(0.45), "timeout")
		
		# Damage the attacker
		if (current_defender):
			current_defender.integrity -= damage
			if (current_defender.integrity <= 0):
				break_defender()
			
			# If defender still exists
			if (current_defender):
				scale_program(current_defender, current_defender.max_integrity, $Attacker/AttackerSprite)
				
				if (type_adv && current_defender.integrity > 0):
					# Show that the program took bonus dmg
					var stress = distress_particles.instance()
					stress.emitting = true
					stress.modulate = current_defender.color
					$Attacker.add_child(stress)
				
		else:
			player_damaged(damage)


# Attack the current defender
func _on_AttackerAttackTimer_timeout():
	
	# Damage the defender after waiting
	if (current_attacker):
		# THIS CODE HAS ALSO BEEN SWAPPED TO DEFENDER DUE TO TIME LIMIT
		# Spawn bullet generator
		spawn_attack_particles(current_defender.attack_value, current_defender.color,
			$Attacker, $Defender)
	
		# Calculate the damage to be done
		var damage
		var type_adv = false
		if (Hacker.strong_against(current_defender.type) == current_attacker.type):
			damage = current_defender.attack_value * TYPE_MULTIPLIER
			type_adv = true
		else:
			damage = current_defender.attack_value
		
		# Wait a given delay 1 second
		yield(get_tree().create_timer(0.45), "timeout")
		current_attacker.integrity -= damage
		
		if (current_attacker.integrity <= 0):
			break_attacker()
		
		# Scale the program to show damage
		if (current_attacker):
			scale_program(current_attacker, current_attacker.max_integrity, $Defender/DefenderSprite)
			
			if (type_adv && current_attacker.integrity > 0):
				# Show that the program took bonus dmg
				var stress = distress_particles.instance()
				stress.emitting = true
				stress.modulate = current_attacker.color
				$Defender.add_child(stress)


func spawn_attack_particles(n, color, attacker, defender):
	var flip_particle = false
	for i in range(current_attacker.attack_value * 2):
		var particle = attack_particle.instance()
		attacker.add_child(particle)
		particle.global_position = attacker.global_position
		particle.destination = defender.global_position
		particle.begin(flip_particle)
		particle.modulate = color
		flip_particle = !flip_particle


func scale_program(program, max_integrity, visualizer):

	var value = float(program.integrity) / float(max_integrity)
	if (value < 0):
		value = 0
	
	var scaled = Vector2(value, value)
	visualizer.rect_scale = scaled


func player_damaged(damage):
	Hacker.gain_trace(float(damage) / float(hacker_dmg_reduction))
	if (! $Damaged.is_playing()):
		$Damaged.play("player_damaged")
