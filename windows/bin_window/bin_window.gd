extends Control


const MAX_PROGRAMS = 5
const TEXT_EDIT_CHAR_LIMIT = 15
const COLOR_REF = {
	"Orange": Color.orange,
	"Orangered": Color.orangered,
	"Green": Color.lawngreen,
	"Blue": Color.blue,
	"White": Color.white,
	"Orchid": Color.orchid,
	"Red": Color.red,
	"Royalblue": Color.royalblue
}

onready var program_button_res = load("res://windows/bin_window/program_button.tscn")
onready var program_res = load("res://programs/PROGRAM.gd")

var program_list = []
var text_edit_content = ""
var program_in_edit = null
var max_points = 0

func _ready():
	# Set up transition buttons
	$Main/Rows/NewButton.connect("pressed", self, "new_button")
	$EditCosmetics/NextButton.connect("button_down", self, "next_button")
	$EditStats/DoneButton.connect("button_down", self, "done_button")
	$EditCosmetics/Columns/Rows/NameEdit.connect("text_changed", self, "handle_text_edit_change")
	
	# Set up color buttons
	for button in get_tree().get_nodes_in_group("ColorButton"):
		var normal_style = StyleBoxFlat.new()
		var hovered_style = StyleBoxFlat.new()
		var pressed_style = StyleBoxFlat.new()
		normal_style.bg_color = COLOR_REF[button.name]
		hovered_style.bg_color = COLOR_REF[button.name].lightened(0.15)
		pressed_style.bg_color = COLOR_REF[button.name].darkened(0.3)
		button.set("custom_styles/normal", normal_style)
		button.set("custom_styles/hover", hovered_style)
		button.set("custom_styles/pressed", pressed_style)
		button.set("custom_styles/focus", StyleBoxEmpty.new())
		button.connect("button_down", self, "color_button", [button.name])
		
	# Set up type buttons
	for button in get_tree().get_nodes_in_group("TypeButton"):
		button.connect("button_down", self, "type_button", [button.name])

	# Set up stat buttons
	max_points = 5 # Get from hacker.gd
	for roller in $EditStats/Rows/StatRows.get_children():
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
	for roller in $EditStats/Rows/StatRows.get_children():
		roller.reset()
		if (copy_in_edit):
			roller.set_value(program_in_edit.get(roller.stat_name))

func update_rollers():
	var total = program_in_edit.total()
	var assigned = 0
	for roller in $EditStats/Rows/StatRows.get_children():
		assigned += roller.cur_value
	for roller in $EditStats/Rows/StatRows.get_children():
		roller.max_value = max_points
		roller.remaining = max_points - assigned
	$EditStats/Rows/Points/Counter.text = str(max_points - assigned)

# Transition buttons
func new_button():
	if program_list.size() >= MAX_PROGRAMS:
		print("You have reached the maximum number of programs.")
		return
	var p = program_res.new()
	p.color = Color.white
	for button in get_tree().get_nodes_in_group("ColorButton"):
		button.pressed = false
	$EditCosmetics/Columns/Rows/ColorSelect/VBoxContainer/HBoxContainer2/White.pressed = true
	p.type = "hybrid"
	for button in get_tree().get_nodes_in_group("TypeButton"):
		button.pressed = false
	$EditCosmetics/Columns/TypeSelect/VBoxContainer/Hybrid.pressed = true
	p.name = "Program" + str(program_list.size())
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
	for button in get_tree().get_nodes_in_group("ColorButton"):
		if button.name != color:
			button.pressed = false
	if program_in_edit:
		program_in_edit.color = COLOR_REF[color]
		
func type_button(type):
	for type_button in get_tree().get_nodes_in_group("TypeButton"):
		if type_button.name != type:
			type_button.pressed = false
	if program_in_edit:
		program_in_edit.type = type.to_lower()

func handle_text_edit_change(new_text):
	text_edit_content = new_text

func read_roller(roller):
	var stat = roller.stat_name
	var value = roller.cur_value
	var diff = program_in_edit.get(stat) - value
	#print("STAT: ", stat, " DIFF: ", diff, " VAL: ", value)
	update_rollers()
	program_in_edit.set(stat, value)

# Queue buttons
func dequeue_program_egress(p):
	pass
	
func dequeue_program_ingress(p):
	pass
