extends VBoxContainer

@export var actor : Actor

#func _ready() -> void:
#	load_actor(actor)

func load_actor(_actor : Actor):
	actor = _actor
	#%Icon.texture = actor.icon
	%CharacterTitle.load_actor_info(_actor.actor_info)
	%RuneBoard.actor = actor
	%AttributesList.load_actor(actor)
