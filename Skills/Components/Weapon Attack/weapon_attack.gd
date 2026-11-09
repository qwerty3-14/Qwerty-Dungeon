extends BaseWeaponAttack
class_name WeaponAttack


func _on_ready() -> void:
	skill_parent.aquired_by_actor.connect(_on_aquired_by_actor)

func _on_aquired_by_actor(_actor : Actor):
	_actor.set_default_weapon_attack(self)
	
