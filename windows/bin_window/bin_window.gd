extends Control

const MAX_PROGRAMS = 5

onready var program_button_res = load("res://windows/bin_window/program_button.tscn")
onready var program_res = load("res://programs/PROGRAM.gd")

var program_list = []

func _ready():
	#update_list()
	$Main/NewButton.connect("button_down", self, "new_button")
	$EditCosmetics/NextButton.connect("button_down", self, "next_button")
	$EditStats/DoneButton.connect("button_down", self, "done_button")
	transition_to("main")

func update_list():
	for child in $Main/ProgramList.get_children():
		$Main/ProgramList.remove_child(child)
	for program in program_list:
		var entry = program_button_res.instance()
		entry.set_appearance(program.color, "New")
		$Main/ProgramList.add_child(entry)

func update_editors(p):
	pass

func new_button():
	if program_list.size() >= MAX_PROGRAMS:
		print("You have reached the maximum number of programs.")
		return
	var p = program_res.new()
	#Add program to list and begin editing it
	program_list.append(p)
	update_editors(p)
	transition_to("cosmetics")

func next_button():
	transition_to("stats")

func done_button():
	update_list()
	transition_to("main")

func transition_to(menu):
	if (menu == "main"):
		$EditStats.visible = false
		$Main.visible = true
	elif (menu == "cosmetics"):
		$Main.visible = false
		$EditCosmetics.visible = true
	elif (menu == "stats"):
		$EditCosmetics.visible = false
		$EditStats.visible = true
	else:
		print("ERROR - menu not found:", menu)
