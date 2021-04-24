extends Control

export (String) var file_name
export (bool) var encrypted = false
export (int) var id

# Vars for generating the program
export (bool) var trap = false
export (int) var integrity
export (int) var attack_rate
export (int) var attack_value
export (String) var type = "neutral"
export (int) var bit_reward = 0


onready var egress_queue = get_tree().get_nodes_in_group("egress")[0]


func _ready():
	$Button.text = file_name
	egress_queue.connect("decrypted", self, "check_id")



func _on_Button_pressed():
	
	# If encrypted instance program in queue
	if (encrypted && egress_queue.is_free()):
		egress_queue.instance_program(trap, integrity, attack_rate, attack_value, type, id)
	elif (! encrypted):
		score_bits()
		queue_free()


func check_id(id):
	
	# if the program for this file was defeated
	if (self.id == id):
		# decrypt the file
		decrypt_file()



func decrypt_file():
	encrypted = false
	$Button.text = $Button.text + " (decrypted)"


func score_bits():
	print("Gained ", bit_reward, " bits")
