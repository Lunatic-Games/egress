extends Control

const type_delay = 0.1
const blink_delay = 0.4
const fdisk_output = """Disk /dev/sda: 465.8 GiB, 500107862016 bytes, 976773168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: LUDAM-DARE-48

Device         Start       End   Sectors   Size Type
/dev/sda1       2048    206847    204800   100M EFI System
/dev/sda2     206848 975736831 476006400   227G Egress filesystem"""

const godot_output = """

MADE WITH GODOT ENGINE
"""

const lunatic_output = """
 ====
==  LUNATIC
==   GAMES
 ===="""

const people_output = """
|- Joe "Holeboi" Zlonicky
|- Matthias "Matthias" Harden
|- Noah "Joe" Jacobsen
|- Bella "Ignored me" Granillo-Bastien
|_ Davis "Richard" Carlson
"""

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	yield(blink(2), "completed")
	yield(type_line("initialize \n", 0.5), "completed")
	yield(add_line("intializing", 0.75), "completed")
	yield(type_line("...\n", 0.5), "completed")
	yield(add_line(fdisk_output, 1.0), "completed")
	yield(add_line(godot_output, 1.0), "completed")
	for line in lunatic_output.split("\n"):
		yield(add_line(line + "\n", 0.5), "completed")
	yield(get_tree().create_timer(0.5), "timeout")
	for line in people_output.split("\n"):
		yield(add_line(line + "\n", 0.5), "completed")
	yield(get_tree().create_timer(0.5), "timeout")
	yield(add_line("LG:/> "), "completed")
	yield(blink(3), "completed")
	yield(type_line("run main_menu\n", 0.5), "completed")
	yield(type_line("...\n", 1.0), "completed")
	var _ret = get_tree().change_scene("res://menus/main_menu/main_menu.tscn")

func blink(n):
	for i in n:
		yield(get_tree().create_timer(blink_delay), "timeout")
		$MarginContainer/MenuLabel.text += "_"
		yield(get_tree().create_timer(blink_delay), "timeout")
		$MarginContainer/MenuLabel.text = $MarginContainer/MenuLabel.text.rstrip("_")
	yield(get_tree().create_timer(blink_delay), "timeout")
		
		
func type_line(string, end_delay=0.0):
	for character in string:
		$MarginContainer/MenuLabel.text += character
		disable_scrollbar()
		yield(get_tree().create_timer(type_delay), "timeout")
	yield(get_tree().create_timer(end_delay), "timeout")


func add_line(string, end_delay=0.0):
	$MarginContainer/MenuLabel.text += string
	disable_scrollbar()
	yield(get_tree().create_timer(end_delay), "timeout")


func disable_scrollbar():
	$MarginContainer/MenuLabel.get_child(0).modulate.a = 0
	$MarginContainer/MenuLabel.get_child(0).mouse_filter = MOUSE_FILTER_IGNORE
