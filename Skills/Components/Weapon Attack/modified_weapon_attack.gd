extends BaseWeaponAttack

signal weapon_attack_updated()

@export var attack_name : String = "Attack"
@onready var modi_repeats : int = repeats
@onready var modi_bonus_damage : int = bonus_damage
@onready var modi_bonus_damage_multiplier : float = bonus_damage_multiplier

func inherit_default_weapon_attack(weapon_attack : WeaponAttack):
	if target_range and action and action.inputs_done.is_connected(target_range.clear_renders):
		action.inputs_done.disconnect(target_range.clear_renders)
	target_range = weapon_attack.target_range
	damage_type = weapon_attack.damage_type
	bonus_damage = weapon_attack.bonus_damage + modi_bonus_damage
	bonus_damage_multiplier = weapon_attack.bonus_damage_multiplier * modi_bonus_damage_multiplier
	repeats = weapon_attack.repeats * (1 + modi_repeats)
	weapon_attack_damage.damage_type = damage_type
	if action and target_range:
		action.inputs_done.connect(target_range.clear_renders)
	weapon_attack_updated.emit()


func _on_ready() -> void:
	skill_parent.aquired_by_actor.connect(_on_aquired_by_actor)
	$WeaponAttackAI.get_node("SingleTargetAttackAI").attack_name = attack_name

func _on_aquired_by_actor(_actor : Actor):
	_actor.default_weapon_attack_updated.connect(_on_default_weapon_attack_updated)
	if _actor.default_weapon_attack:
		inherit_default_weapon_attack(_actor.default_weapon_attack)
		$WeaponAttackAI.get_node("SingleTargetAttackAI").target_range = target_range

func _on_default_weapon_attack_updated(weapon_attack : WeaponAttack):
		inherit_default_weapon_attack(weapon_attack)
