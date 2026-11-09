extends PanelContainer
class_name SkillListItem

signal hovered(_skill_info : SkillInfo)

var skill_info : SkillInfo

func load_skill_info(_skill_info : SkillInfo):
	skill_info = _skill_info
	%SkillIcon.texture = _skill_info.icon
	%SkillName.text = _skill_info.display_name


func _on_mouse_entered() -> void:
	hovered.emit(skill_info)
