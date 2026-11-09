extends Control
class_name SkillTree

signal points_changed(_points : int)
signal actor_loaded(_actor : Actor)

@export var combat_class : String = "Class Name"
@export var actor : Actor

var points : int = 0

func _on_skill_aquired(key : String):
	if actor:
		SkillLibrary.give_skill_to_actor(actor, key)
		#skill.duplicate().move_to_actor(actor)
	points -= 1
	points_changed.emit(points)

func load_actor(_actor : Actor):
	actor = _actor
	actor_loaded.emit(actor)

func give_point():
	points += 1
	points_changed.emit(points)
