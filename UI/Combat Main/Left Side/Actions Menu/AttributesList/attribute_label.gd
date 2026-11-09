extends RichTextLabel
class_name AttributeLabel

var attribute : Attribute

func load_attribute(new_attribute : Attribute):
	if attribute:
		if attribute.value_changed.is_connected(_on_attribute_value_changed):
			attribute.value_changed.disconnect(_on_attribute_value_changed)
	
	attribute = new_attribute
	text = attribute.colored_text()
	attribute.value_changed.connect(_on_attribute_value_changed)

func _on_attribute_value_changed(_value : int):
	text = attribute.colored_text()
