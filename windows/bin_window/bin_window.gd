extends Control


const MAX_PROGRAMS = 5
const TEXT_EDIT_CHAR_LIMIT = 15
const COLOR_REF = {
	"Orange": Color.orange,
	"Yellow": Color.yellow,
	"Green": Color.green,
	"Blue": Color.blue,
	"White": Color.white,
	"Pink": Color.pink,
	"Red": Color.red,
	"Purple": Color.purple
}

onready var program_button_res = load("res://windows/bin_window/program_button.tscn")
onready var program_res = load("res://programs/PROGRAM.gd")

var program_list = []
var text_edit_content = ""
var program_in_edit = null

func _ready():
	#update_list()
	$Main/NewButton.connect("button_down", self, "new_button")
	$EditCosmetics/NextButton.connect("button_down", self, "next_button")
	$EditStats/DoneButton.connect("button_down", self, "done_button")
	$EditCosmetics/Columns/Rows/NameEdit.connect("text_changed", self, "handle_text_edit_change")
	transition_to("main")


func edit_program(p):
	update_editors(p)
	program_in_edit = p
	transition_to("cosmetics")

func update_list():
	for child in $Main/ProgramList.get_children():
		$Main/ProgramList.remove_child(child)
	for program in program_list:
		var entry = program_button_res.instance()
		entry.init(program)
		$Main/ProgramList.add_child(entry)
	text_edit_content = ""

func update_editors(p):
	text_edit_content = p.name
	$EditCosmetics/Columns/Rows/NameEdit.text = text_edit_content
	for button in get_tree().get_nodes_in_group("ColorButton"):
		button.modulate = COLOR_REF[button.name]
		button.connect("button_down", self, "color_button", [button.name])

func new_button():
	if program_list.size() >= MAX_PROGRAMS:
		print("You have reached the maximum number of programs.")
		return
	var p = program_res.new()
	p.color = Color.cyan
	#Add program to list and begin editing it
	program_list.append(p)
	edit_program(p)

func next_button():
	program_in_edit.name = text_edit_content
	transition_to("stats")

func done_button():
	update_list()
	program_in_edit = null
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

func color_button(color):
	if program_in_edit:
		program_in_edit.color = COLOR_REF[color]

func handle_text_edit_change():
	var new_text = $EditCosmetics/Columns/Rows/NameEdit.text
	if new_text.length() >= TEXT_EDIT_CHAR_LIMIT:
		var cursor_column = $EditCosmetics/Columns/Rows/NameEdit.cursor_get_column()
		$EditCosmetics/Columns/Rows/NameEdit.text = text_edit_content
		$EditCosmetics/Columns/Rows/NameEdit.cursor_set_column(cursor_column - 1)
	else:
		text_edit_content = new_text
