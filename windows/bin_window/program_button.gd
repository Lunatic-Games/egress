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
	controller.edit_program(p)
	
func egress_button():
	print("Moving program [", p.name, "] to egress...")
	
func ingress_button():
	print("Moving program [", p.name, "] to ingress...")
