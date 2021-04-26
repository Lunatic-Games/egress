extends HBoxContainer


export(String) var stat_name
export(int) var cur_value = 0
export(int) var remaining
export(int) var max_value

signal update_stat(stat_name, cur_value)

func _ready():
	var _ret = $Up.connect("button_down", self, "up_button")
	_ret = $Down.connect("button_down", self, "down_button")
	
func up_button():
	if (cur_value < max_value && remaining > 0):
		cur_value += 1
		$Counter.text = String(cur_value)
		emit_signal("update_stat")

func down_button():
	if (cur_value > 0):
		cur_value -= 1
		$Counter.text = String(cur_value)
		emit_signal("update_stat")
		
func set_value(val):
	cur_value = val
	$Counter.text = String(cur_value)

func reset():
	cur_value = 0
	remaining = 0
	max_value = 0
	$Counter.text = "0"
