extends Control

const MAX_PROGRAMS = 15

onready var program_button_res = load("res://windows/bin_window/program_button.tscn")
onready var program_res = load("res://programs/PROGRAM.gd")

var program_list = []
#	{"ID": "1", "color": Color.cyan, "name": "pwDICT_roller"},
#	{"ID": "2", "color": Color.red, "name": "LZW_decrypt"}

func _ready():
	#update_list()
	$Main/NewButton.connect("button_down", self, "new_button")

func update_list():
	for child in $Main/ProgramList.get_children():
		$Main/ProgramList.remove_child(child)
	for program in program_list:
		var entry = program_button_res.instance()
		entry.set_appearance(program["color"], program["name"])
		$Main/ProgramList.add_child(entry)

func new_button():
	print("Click!")
	if program_list.size() >= MAX_PROGRAMS:
		print("You have reached the maximum number of programs.")
		return
	program_list.append({
		"ID": "0",
		"color": Color.cyan,
		"name": "new"
	})
	update_list()
