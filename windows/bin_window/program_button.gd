extends Control


onready var controller = get_tree().get_nodes_in_group("BinWindowController")[0]
onready var ingress = get_tree().get_nodes_in_group("ingress")[0]
onready var egress = get_tree().get_nodes_in_group("egress")[0]

var p
var allow_edit = true
var deployed = false

func init(program_struct):
	p = program_struct
	$HBoxContainer/ProgramShader.modulate = p.color
	$HBoxContainer/NameLabel.text = p.name
	var _ret = $HBoxContainer/EditButton.connect("button_down", self, "edit_button")
	_ret = $HBoxContainer/EgressButton.connect("button_down", self, "egress_button")
	_ret = $HBoxContainer/IngressButton.connect("button_down", self, "ingress_button")



func edit_button():
	if (allow_edit):
		$UiStreamPlayer.play()
		controller.edit_program(p, true)
	
func egress_button():
	if ($HBoxContainer/EgressButton.pressed):
		#print("Dequeueing [", p.name, "] from egress...")
		if (deployed):
			egress.dequeue_attacker(p)
			deployed = false
			allow_edit = true
			$UiStreamPlayer.play()
		else:
			$HBoxContainer/EgressButton.pressed = false
	else:
		#print("Queueing [", p.name, "] to egress...")
		if (not deployed):
			egress.queue_attacker(p)
			deployed = true
			allow_edit = false
			$LoadStreamPlayer.play()
		else:
			$HBoxContainer/EgressButton.pressed = true

func ingress_button():
	if ($HBoxContainer/IngressButton.pressed):
		#print("Dequeueing [", p.name, "] from ingress...")
		if (deployed):
			ingress.dequeue_defender(p)
			deployed = false
			allow_edit = true
			$UiStreamPlayer.play()
		else:
			$HBoxContainer/IngressButton.pressed = false
	else:
		#print("Queueing [", p.name, "] to ingress...")
		if (not deployed):
			ingress.defenders.push_back(p)
			deployed = true
			allow_edit = false
			$LoadStreamPlayer.play()
		else:
			$HBoxContainer/IngressButton.pressed = true

func reset_egress_button():
	pass
	
func reset_ingress_button(program):
	if (program.name == p.name):
		_do_recharge()

func _do_recharge():
	$RechargeOverlay.visible = true
	$HBoxContainer/IngressButton.pressed = true
	$HBoxContainer/EgressButton.pressed = true
	allow_edit = false
	
	yield(get_tree().create_timer(p.recharge_rate), "timeout")
	
	$RechargeOverlay.visible = false
	$HBoxContainer/IngressButton.pressed = false
	$HBoxContainer/EgressButton.pressed = false
	allow_edit = true
	deployed = false

	
