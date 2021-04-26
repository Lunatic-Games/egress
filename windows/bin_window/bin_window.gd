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
var max_points = 0

func _ready():
	# Set up transition buttons
	$Main/Rows/NewButton.connect("button_down", self, "new_button")
	$EditCosmetics/NextButton.connect("button_down", self, "next_button")
	$EditStats/Rows/DoneButton.connect("button_down", self, "done_button")
	$EditCosmetics/Columns/Rows/NameEdit.connect("text_changed", self, "handle_text_edit_change")
	
	# Set up color buttons
	for button in get_tree().get_nodes_in_group("ColorButton"):
		button.modulate = COLOR_REF[button.name]
		button.connect("button_down", self, "color_button", [button.name])
		
	# Set up type buttons
	for button in get_tree().get_nodes_in_group("TypeButton"):
		button.connect("button_down", self, "type_button", [button.name])

	# Set up stat buttons
	max_points = 5 # Get from hacker.gd
	for roller in $EditStats/Rows/GroupColumns/StatColumns.get_children():
		roller.max_value = max_points
		roller.connect("update_stat", self, "read_roller", [roller])

	transition_to("main")


func edit_program(p, from_existing=false):
	program_in_edit = p
	reset_rollers(true)
	update_editors()
	transition_to("cosmetics")

func update_list():
	for child in $Main/Rows/ScrollContainer/ProgramList.get_children():
		$Main/Rows/ScrollContainer/ProgramList.remove_child(child)
	for program in program_list:
		var entry = program_button_res.instance()
		entry.init(program)
		$Main/Rows/ScrollContainer/ProgramList.add_child(entry)
	text_edit_content = ""

func update_editors():
	text_edit_content = program_in_edit.name
	$EditCosmetics/Columns/Rows/NameEdit.text = text_edit_content
	update_rollers()

func reset_rollers(copy_in_edit=false):
	for roller in $EditStats/Rows/GroupColumns/StatColumns.get_children():
		roller.reset()
		if (copy_in_edit):
			roller.set_value(program_in_edit.get(roller.stat_name))

func update_rollers():
	var total = program_in_edit.total()
	var assigned = 0
	for roller in $EditStats/Rows/GroupColumns/StatColumns.get_children():
		assigned += roller.cur_value
	for roller in $EditStats/Rows/GroupColumns/StatColumns.get_children():
		roller.max_value = max_points
		roller.remaining = max_points - assigned
		#print(roller.stat_name, ", Roller: ", roller.cur_value, ", Program: ", program_in_edit.get(roller.stat_name))

# Transition buttons
func new_button():
	if program_list.size() >= MAX_PROGRAMS:
		print("You have reached the maximum number of programs.")
		return
	var p = program_res.new()
	p.color = Color.white
	#Add program to list and begin editing it
	program_list.append(p)
	edit_program(p)

func next_button():
	program_in_edit.name = text_edit_content
	transition_to("stats")

func done_button():
	update_list()
	program_in_edit = null
	reset_rollers()
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

# Editor buttons
func color_button(color):
	if program_in_edit:
		program_in_edit.color = COLOR_REF[color]
		
func type_button(type):
	if program_in_edit:
		program_in_edit.type = type.to_lower()

func handle_text_edit_change():
	var new_text = $EditCosmetics/Columns/Rows/NameEdit.text
	if new_text.length() >= TEXT_EDIT_CHAR_LIMIT:
		var cursor_column = $EditCosmetics/Columns/Rows/NameEdit.cursor_get_column()
		$EditCosmetics/Columns/Rows/NameEdit.text = text_edit_content
		$EditCosmetics/Columns/Rows/NameEdit.cursor_set_column(cursor_column - 1)
	else:
		text_edit_content = new_text

func read_roller(roller):
	var stat = roller.stat_name
	var value = roller.cur_value
	var diff = program_in_edit.get(stat) - value
	#print("STAT: ", stat, " DIFF: ", diff, " VAL: ", value)
	update_rollers()
	program_in_edit.set(stat, value)
