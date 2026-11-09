extends HBoxContainer
class_name CharacterTitle


func load_actor_info(_actor_info : ActorInfo):
	%Icon.texture = _actor_info.icon
	%NameLabel.text = _actor_info.character_name
	%ClassLabel.text = _actor_info.combat_class

func wipe_actor():
	%Icon.texture = null
	%NameLabel.text = "???"
	%ClassLabel.text = "???"
