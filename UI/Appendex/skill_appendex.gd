extends Control
class_name SkillAppendex

var previous_scene : CanvasItem

func _ready() -> void:
	for skill_info : SkillInfo in SkillLibrary.info_dict.values():
		var new_item : SkillListItem = %SkillListItem.duplicate()
		new_item.load_skill_info(skill_info)
		%SkillVBox.add_child(new_item)
	%SkillListItem.queue_free()


func _on_skill_list_item_hovered(_skill_info : SkillInfo) -> void:
	%InfoPanel.load_skill_info(_skill_info)


func _on_return_button_pressed() -> void:
	if previous_scene:
		previous_scene.visible = true
		visible = false
