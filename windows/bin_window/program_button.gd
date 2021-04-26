extends Control


var p
onready var controller = get_tree().get_nodes_in_group("BinWindowController")[0]
onready var ingress = get_tree().get_nodes_in_group("ingress")[0]
onready var egress = get_tree().get_nodes_in_group("egress")[0]

func init(program_struct):
	p = program_struct
	$HBoxContainer/ProgramShader.modulate = p.color
	$HBoxContainer/NameLabel.text = p.name
	$HBoxContainer/EditButton.connect("button_down", self, "edit_button")
	$HBoxContainer/EgressButton.connect("button_down", self, "egress_button")
	$HBoxContainer/IngressButton.connect("button_down", self, "ingress_button")


func edit_button():
	controller.edit_program(p, true)
	
func egress_button():
	if ($HBoxContainer/EgressButton.pressed):
		#print("Dequeueing [", p.name, "] from egress...")
		egress.dequeue_attacker(p)
	else:
		#print("Queueing [", p.name, "] to egress...")
		egress.queue_attacker(p)
	
func ingress_button():
	if ($HBoxContainer/IngressButton.pressed):
		#print("Dequeueing [", p.name, "] from ingress...")
		pass
		# DEQUEUE DEFENDER HERE
	else:
		#print("Queueing [", p.name, "] to ingress...")
		ingress.defenders.push_back(p)
