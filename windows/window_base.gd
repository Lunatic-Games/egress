extends ColorRect

const BAR_HEIGHT = 28
const BAR_MARGIN = 4
const TEXT_MARGIN = 2*BAR_MARGIN

export(String) var win_name
export(String) var source_path

var content

func _ready():
	$WindowName.text = win_name
	$WindowName.rect_position = Vector2(TEXT_MARGIN, TEXT_MARGIN)
	$WindowBar.rect_position = Vector2(BAR_MARGIN, BAR_MARGIN)
	$WindowBar.rect_size = Vector2(self.rect_size.x-2*BAR_MARGIN, BAR_HEIGHT)
	var content_source = load(source_path)
	content = content_source.instance()
	content.rect_position = Vector2(0, BAR_HEIGHT)
	#content.rect_size = Vector2(win_rect.size.x, win_rect.size.y - BAR_HEIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
