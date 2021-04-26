extends ColorRect

export (Array, Resource) var attackers = []

onready var TYPE_MULTIPLIER = 2.5

onready var current_attacker
onready var defenders = []
onready var current_defender
onready var hack_underway = false
onready var defender_index = 0
onready var attacker_index = 0

onready var attack_particle = preload("res://programs/attack_particle/attack_particle.tscn")
onready var distress_particles = preload("res://assets/particles/distress_particles.tscn")
onready var ingress = get_tree().get_nodes_in_group('ingress')[0]

var winner_decided = false

signal decrypted


func _process(delta):
	
	# If a hack is happening
	if (hack_underway && !winner_decided  && !($HackSuccessful.is_playing() || $HackFailed.is_playing())):
		
		# Check to break a defending program
		if (current_defender.integrity <= 0):
			break_defender()
		
		# Check to break an attacking program
		if (current_attacker.integrity <= 0):
			break_attacker()


func begin_hack():
	winner_decided = false
	hack_underway = true
	defender_index = 0
	attacker_index = 0
	
	# If there are no attackers
	if (attackers.size() <= 0):
		hack_failed()
	else:
		# TODO CLEAR THE ATTACKER AND DEFENDER
		instance_attacker(attackers[attacker_index])
		instance_defender(defenders[defender_index])


func break_defender():
	defender_index += 1
	
	# Progress to the next defender
	if (defender_index >= defenders.size()):
		print("Defenders: ", defenders)
		hack_successful(defenders[0].host_file, defenders[0].bits)
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
func hack_successful(host_file, bits_gained):
	emit_signal("decrypted", host_file)
	
	# Stop attacking
	winner_decided = true
	$DefenderAttackTimer.stop()
	$AttackerAttackTimer.stop()
	
	for particle in get_tree().get_nodes_in_group("attack_particle"):
		if $Defender.is_a_parent_of(particle):
			particle.fade()
	
	yield(get_tree().create_timer(1.5), "timeout")
	$Defender.visible = false
	$Attacker.visible = false
	
	$AccessGranted/BitsGained.bbcode_text = "[shake][center]+" + String(bits_gained) + " bits![/center][/shake]"
	$HackSuccessful.play("hack_success")
	Hacker.gain_bits(bits_gained)


# Clear the defenders stats and prepare for the next one
func defender_defeated():
	$Defender.visible = false
	$DefenderAttackTimer.stop()


# Signal to the file that the hack was successful
func hack_failed():
	
	# Reset the programs
	winner_decided = true
	$DefenderAttackTimer.stop()
	$AttackerAttackTimer.stop()
	
	print("FAILED")
	for particle in get_tree().get_nodes_in_group("attack_particle"):
		if $Attacker.is_a_parent_of(particle):
			particle.fade()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	$Attacker.visible = false
	$Defender.visible = false
	
	$HackFailed.play("hack_failed")

# Clear the defenders stats and prepare for the next one
func attacker_defeated():
	$Attacker.visible = false
	$AttackerAttackTimer.stop()


func instance_defender(program):
	
	print("Instancing def at ", defender_index)
	
	# If the program is not a trap, treat it normally
	if (! program.trap):
		$Defender/DefenderSprite.visible = true
		$Defender/DefenderSprite.rect_scale = Vector2(1,1)
		$Defender/DefenderSprite.modulate = program.color
		$Defender/DefenderName.bbcode_text = "[center][shake]" + String(program.name)
		$DefenderAttackTimer.start(program.attack_rate)
		$Defender.visible = false
		$DefenderAnimator.play('load_program')
		
		
		current_defender = defenders[defender_index].duplicate()
	
	# If the program is a trap
	else:
		print("Instancing a trap")
		ingress.attackers.push_back(program)
		
		current_defender = defenders[defender_index].duplicate()
		break_defender()


func instance_attacker(program):
	$Attacker/AttackerSprite.visible = true
	$Attacker/AttackerSprite.rect_scale = Vector2(1,1)
	$Attacker/AttackerSprite.modulate = program.color
	$Attacker/AttackerName.bbcode_text = "[center][shake]" + String(program.name)
	$AttackerAttackTimer.start(program.attack_rate)
	
	$Attacker.visible = false
	$AttackerAnimator.play('load_program')
	
	current_attacker = attackers[attacker_index].duplicate()


func queue_defender(program, id, bits_gained):
	program.host_file = id
	program.bits = bits_gained
	defenders.push_back(program)


func queue_attacker(program):
	attackers.push_back(program)
	return attackers.size()

func dequeue_attacker(program):
	var index = attackers.find(program)
	attackers.remove(index)

func is_free():
	return !hack_underway


# attack the current attacker
func _on_DefenderAttackTimer_timeout():
	
	# Spawn bullet generator
	spawn_attack_particles(current_defender.attack_value, 
		current_defender.color, $Defender, $Attacker)
	
	# Calculate the damage to be done
	var damage
	var type_adv = false
	if (Hacker.strong_against(current_defender.type) == current_attacker.type):
		damage = current_defender.attack_value * TYPE_MULTIPLIER
		type_adv = true
	else:
		damage = current_attacker.attack_value
	
	
	# Wait a given delay 1 second
	
	yield(get_tree().create_timer(0.55), "timeout")
	if $DefenderAttackTimer.is_stopped():
		return
	
	# Damage the attacker
	if (attacker_index < attackers.size()):
		current_attacker.integrity -= damage
		scale_program(current_attacker, attackers[attacker_index].integrity, $Attacker/AttackerSprite)
		
		if (type_adv && current_attacker.integrity > 0):
			# Show that the program took bonus dmg
			var stress = distress_particles.instance()
			stress.emitting = true
			stress.modulate = current_attacker.color
			$Attacker.add_child(stress)


# Attack the current defender
func _on_AttackerAttackTimer_timeout():

	# Spawn bullet generator
	spawn_attack_particles(current_attacker.attack_value, current_attacker.color,
		$Attacker, $Defender)
	
	# Calculate the damage to be done
	var damage
	var type_adv = false
	if (Hacker.strong_against(current_attacker.type) == current_defender.type):
		damage = current_attacker.attack_value * TYPE_MULTIPLIER
		type_adv = true
	else:
		damage = current_attacker.attack_value

	# Wait a given delay 1 second
	yield(get_tree().create_timer(0.55), "timeout")
	if $AttackerAttackTimer.is_stopped():
		return
	
	# Damage the defender after waiting
	if (defender_index < defenders.size()):
		current_defender.integrity -= damage
		scale_program(current_defender, defenders[defender_index].integrity, $Defender/DefenderSprite)
		
		if (type_adv && current_defender.integrity > 0):
			print("defender took type dmg")
			# Show that the program took bonus dmg
			var stress = distress_particles.instance()
			stress.emitting = true
			stress.modulate = current_defender.color
			$Defender.add_child(stress)


# Copied for engress and ingress
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


# Allow another hack
func _on_HackSuccessful_animation_finished(anim_name):
	hack_underway = false
	defenders = []


func _on_HackFailed_animation_finished(anim_name):
	hack_underway = false
	defenders = []
