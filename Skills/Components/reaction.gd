extends APSpender
class_name Reaction

func _ready() -> void:
	if get_parent() is Skill:
		var _skill : Skill = get_parent()
