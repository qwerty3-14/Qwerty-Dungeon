@icon("uid://cbbb121j8alm0")
extends Skill

func _on_ready():
	combat_object_grandparent.scorring_damage.connect(_on_cog_scorring_damage)

func _on_cog_scorring_damage(damage : Damage):
	if damage.damage_physical():
		combat_object_grandparent.scorring_damage_sr *= 3
