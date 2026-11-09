extends NinePatchRect

signal hovered()

const ATTRIBUTE_SOURCE_PANEL := preload("uid://dpl2g31j2m8c5")

var attribute : Attribute

func load_attribute(new_attribute : Attribute):
	attribute = new_attribute
	%AttributeLabel.load_attribute(new_attribute)

func _make_custom_tooltip(_for_text: String) -> Object:
	var panel_contents : VBoxContainer = ATTRIBUTE_SOURCE_PANEL.instantiate()
	panel_contents.load_attribute(attribute)
	return panel_contents


func _on_mouse_entered() -> void:
	hovered.emit()


func _on_mouse_exited() -> void:
	pass # Replace with function body.
