extends TextureRect

const ATTRIBUTE_SOURCE_PANEL := preload("uid://dpl2g31j2m8c5")

func load_defenses(defense : Attribute, warding : Attribute):
	$DefenseLabel.load_attribute(defense)
	$WardingLabel.load_attribute(warding)
	
func _make_custom_tooltip(_for_text: String) -> Object:
	var panel_contents : VBoxContainer = ATTRIBUTE_SOURCE_PANEL.instantiate()
	panel_contents.load_attribute($DefenseLabel.attribute)
	return panel_contents
