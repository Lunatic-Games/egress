extends Control

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
	egress_queue.connect("decrypted", self, "score_bits")



func _on_Button_pressed():
	
	# If encrypted instance program in queue
	if (encrypted && egress_queue.is_free()):
		egress_queue.instance_program(trap, integrity, attack_rate, attack_value, type, id)
	else:
		pass


func check_id(id):
	
	# if the program for this file was defeated
	if (self.id == id):
		# Give the user bits
		score_bits(bit_reward)


func score_bits(bits):
	print("Gained ", bits, " bits")
