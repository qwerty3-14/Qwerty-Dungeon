@icon("uid://ba0n4aaimv70t")
extends Skill

func _on_ready():
	combat_object_grandparent.about_to_take_damage.connect(_on_about_to_take_damage)


func _on_about_to_take_damage(damage : Damage):
	if damage.damage_physical() and Globals.rng.randi_range(0, 99) < actor_parent.luck.value * 2:
		combat_object_grandparent.negate_damage = true
		Globals.over_room_renders.text_popup(combat_object_grandparent.tile_position, "Block")
