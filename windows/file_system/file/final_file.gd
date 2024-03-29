extends Control

export (String) var file_name
export (String, MULTILINE) var decrypted_text
export (bool) var encrypted = false
export (bool) var directory = false
export (int) var id
export (int) var bit_reward = 0

# Vars for generating the program
export (Array, Resource) var programs

onready var egress_queue = get_tree().get_nodes_in_group("egress")[0]
onready var file_system = get_tree().get_nodes_in_group("file_system")[0]

var opened = false

func _ready():
	if (encrypted):
		$Button.text = file_name + ".encrypted"
	else:
		$Button.text = file_name

	egress_queue.connect("decrypted", self, "check_id")



func _on_Button_pressed():
	# If encrypted instance program in queue
	if (encrypted && egress_queue.is_free()):
		for program in programs:
			egress_queue.queue_defender(program, id, bit_reward)
		egress_queue.begin_hack()

	elif (!encrypted):
		Hacker.win_game()


func check_id(id):

	# if the program for this file was defeated
	if (self.id == id):
		# decrypt the file
		decrypt_file()



func decrypt_file():
	if (encrypted):
		encrypted = false
		$Button.text = $Button.text.substr(0, $Button.text.length() - 10) + ".decrypted"
