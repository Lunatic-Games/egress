extends Node2D

onready var main_menu = load("res://menus/main_menu/main_menu.tscn")

var tutorial_stages = {
	"new_program": false,
	"next_edit": false,
	"done_edit": false,
	"egress_queue": false,
	"decrypt": false,
	"ingress": false,
	"read": false,
	"done": false
}

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.popup_centered()
		get_tree().set_input_as_handled()


func _on_MenuButton_pressed():
	get_tree().paused = false
	var scene = get_tree().change_scene_to(main_menu)

func _ready():
	$WindowController/BinTutorial.visible = true
	get_tree().get_nodes_in_group("new_program_button")[0].connect("pressed", 
		self, "next_tutorial", [$WindowController/BinTutorial, 
		$WindowController/ProgramEditTutorial, "new_program"])
		
	get_tree().get_nodes_in_group("next_edit_button")[0].connect("pressed", 
		self, "next_tutorial", [$WindowController/ProgramEditTutorial, 
		$WindowController/StatEditTutorial, "next_edit"])
		
	get_tree().get_nodes_in_group("program_edit_done_button")[0].connect("pressed", 
		self, "next_tutorial", [$WindowController/StatEditTutorial, 
		$WindowController/QueueTutorial, "done_edit"])

	get_tree().get_nodes_in_group("file_button")[0].connect("pressed", self,
		"next_tutorial", [$WindowController/DecryptTutorial, 
		$WindowController/BattleTutorial, "decrypt"])

func next_tutorial(current_overlay, next_overlay, tutorial_name):
	if (tutorial_name == "decrypt" and tutorial_stages["decrypt"]
			and not tutorial_stages["done"]):
		$WindowController/ReadTutorial.visible = false
		tutorial_stages["done"] = true
		return
	if tutorial_stages[tutorial_name]:
		return
	if tutorial_name == "done_edit":
		get_tree().get_nodes_in_group("insert_egress_button")[0].connect("pressed", 
		self, "next_tutorial", [$WindowController/QueueTutorial, 
		$WindowController/DecryptTutorial, "egress_queue"])
	tutorial_stages[tutorial_name] = true
	current_overlay.visible = false
	next_overlay.visible = true
	
	if tutorial_name == "decrypt":
		yield(get_tree().create_timer(12.0), "timeout")
		next_tutorial($WindowController/BattleTutorial, 
			$WindowController/IngressTutorial, "ingress")
	
	if tutorial_name == "ingress":
		yield(get_tree().create_timer(10.0), "timeout")
		next_tutorial($WindowController/IngressTutorial, 
			$WindowController/ReadTutorial, "read")

