extends Control


var p
onready var controller = get_tree().get_nodes_in_group("BinWindowController")[0]

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
		controller.dequeue_program_egress(p)
	else:
		#print("Queueing [", p.name, "] to egress...")
		var egress = get_tree().get_nodes_in_group("egress")[0]
		egress.queue_attacker(p)
	
func ingress_button():
	if ($HBoxContainer/IngressButton.pressed):
		#print("Dequeueing [", p.name, "] from ingress...")
		controller.dequeue_program_ingress(p)
	else:
		#print("Queueing [", p.name, "] to ingress...")
		var ingress = get_tree().get_nodes_in_group("ingress")[0]
		ingress.defenders.push_back(p)
