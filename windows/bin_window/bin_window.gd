extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const program_resource = preload("res://windows/bin_window/program_button.tscn")

var programs = [
	{"ID": "1", "color": Color.cyan, "name": "pwDICT_roller"},
	{"ID": "2", "color": Color.red, "name": "LZW_decrypt"}
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_list()

func update_list():
	for program in programs:
		var entry = program_resource.instance()
		entry.set_appearance(program["color"], program["name"])
		$ProgramList.add_child(entry)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
