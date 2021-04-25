extends ColorRect

export (Array, Resource) var attackers = []

var defender_stats = {}
var attacker_stats = {}


onready var current_attacker
onready var defenders = []
onready var current_defender
onready var hack_underway = false
onready var defender_index = 0
onready var attacker_index = 0

onready var attacker_bullets = preload("res://assets/particles/attacker_particles.tscn")
onready var defender_bullets = preload("res://assets/particles/defender_particles.tscn")


signal decrypted


func _process(delta):
	
	# If a hack is happening
	if (hack_underway && ! ($HackSuccessful.is_playing() || $HackFailed.is_playing())):
		
		# Check to break a defending program
		if (current_defender.integrity <= 0):
			break_defender()
		
		# Check to break an attacking program
		if (current_attacker.integrity <= 0):
			break_attacker()


func begin_hack():
	
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
	emit_signal("decrypted", host_file)
	
	# Stop attacking
	$DefenderAttackTimer.stop()
	$AttackerAttackTimer.stop()
	
	print("Playing hack_success")
	$HackSuccessful.play("hack_success")


# Clear the defenders stats and prepare for the next one
func defender_defeated():
	$Defender.visible = false
	$DefenderAttackTimer.stop()


# Signal to the file that the hack was successful
func hack_failed():
	
	# Reset the programs
	$DefenderAttackTimer.stop()
	$AttackerAttackTimer.stop()
	
	$HackFailed.play("hack_failed")

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
	
	current_defender = defenders[defender_index].duplicate()


func instance_attacker(program):
	$Attacker/AttackerSprite.visible = true
	$Attacker/AttackerSprite.rect_scale = Vector2(1,1)
	$Attacker/AttackerSprite.modulate = program.color
	$Attacker/AttackerName.bbcode_text = "[center][shake]" + String(program.name)
	$AttackerAttackTimer.start(program.attack_rate)
	
	$AttackerAnimator.play('load_program')
	$Attacker.visible = true
	
	current_attacker = attackers[attacker_index].duplicate()


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
	if (attacker_index < attackers.size()):
		current_attacker.integrity -= current_defender.attack_value
		scale_program(current_attacker, attackers[attacker_index].integrity, $Attacker/AttackerSprite)


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
	if (defender_index < defenders.size()):
		current_defender.integrity -= current_attacker.attack_value
		scale_program(current_defender, defenders[defender_index].integrity, $Defender/DefenderSprite)


func scale_program(program, max_integrity, visualizer):

	var value = float(program.integrity) / float(max_integrity)
	if (value < 0):
		value = 0
	
	var scaled = Vector2(value, value)
	print("New scale", scaled)
	visualizer.rect_scale = scaled


# Allow another hack
func _on_HackSuccessful_animation_finished(anim_name):
	print("Animation Finished")
	hack_underway = false
	defenders = []


func _on_HackFailed_animation_finished(anim_name):
	hack_underway = false
	defenders = []
