extends Control
class_name SetupSkillSlot

signal  moused_over(_skill : Skill)

var skill : Skill

func load_skill(_skill : Skill):
	%Button.disabled = false
	skill = _skill
	if skill:
		%Icon.texture = skill.icon

func update_hotbar(key : int):
	if skill:
		skill.actor_parent.hotbar_skills[key] = skill

func _on_button_pressed() -> void:
	if skill:
		skill.actor_parent.hotbar_skills.erase(skill.actor_parent.hotbar_skills.find_key(skill))
		skill = null
		%Icon.texture = null
		%Button.disabled = true


func _on_button_mouse_entered() -> void:
	if skill:
		moused_over.emit(skill)
