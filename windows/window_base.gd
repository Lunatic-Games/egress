extends ColorRect

const BAR_HEIGHT = 32

export(Rect2) var win_rect
export(String) var win_name
export(String) var source_path

var content

func _ready():
	self.rect_position = win_rect.position
	self.rect_size = win_rect.size
	$WindowName.text = win_name
	$WindowBar.rect_size = Vector2(win_rect.size.x, BAR_HEIGHT)
	var content_source = load(source_path)
	content = content_source.instance()
	content.position = Vector2(win_rect.position.x, win_rect.position.y - BAR_HEIGHT)
	content.rect_size = Vector2(win_rect.size.x, win_rect.size.y - BAR_HEIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
