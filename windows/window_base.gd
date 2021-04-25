extends ColorRect

const BAR_HEIGHT = 30
const BAR_MARGIN = 4
const TEXT_MARGIN = Vector2(8, 8)

export(String) var win_name
export(String) var source_path

var content

func _ready():
	$WindowName.text = win_name
	$WindowName.rect_position = TEXT_MARGIN
	$WindowBar.rect_position = Vector2(BAR_MARGIN, BAR_MARGIN)
	$WindowBar.rect_size = Vector2(self.rect_size.x-2*BAR_MARGIN, BAR_HEIGHT)
	var content_source = load(source_path)
	content = content_source.instance()
	content.margin_top = BAR_HEIGHT + 2*BAR_MARGIN
	content.margin_bottom = -BAR_MARGIN
	content.margin_left = BAR_MARGIN
	content.margin_right = -BAR_MARGIN
	$Content.add_child(content)
