extends Control
class_name AvailibleSkillSlot

signal  moused_over(_skill : Skill)

var skill : Skill

func load_skill(_skill : Skill):
	skill = _skill
	%Icon.texture = skill.icon


func _on_icon_mouse_entered() -> void:
	moused_over.emit(skill)
