extends Node
class_name Potion

signal transformed()
signal reverted()
signal imbue_confirmed()

enum modes {DRINK, IMBUE}

@export_category("Alt Icons")
@export var default_icon : Texture2D
@export var imbue_icon : Texture2D

@export_category("Other")
@export var action : Action

var skill_parent : Skill
var current_mode : modes = modes.DRINK

func _ready() -> void:
	if get_parent() is Skill:
		skill_parent = get_parent()
		skill_parent.attached_to_hotbar_slot.connect(_on_skill_parent_attached_to_hotbar_slot)
		skill_parent.removed_from_hotbar_slot.connect(_on_skill_parent_removed_from_hotbar_slot)
		for sibling_skill : Skill in skill_parent.get_parent().get_children().filter(func(node : Node): return node.has_signal("potion_to_imbue_requested")):
			sibling_skill.potion_to_imbue_requested.connect(_on_potion_to_imbue_requested)
			sibling_skill.imbue_action_ended.connect(_on_imbue_action_ended)
			imbue_confirmed.connect(sibling_skill._on_potion_imbue_confirmed)
	else:
		printerr("Parent must be skill")

func _on_potion_to_imbue_requested():
	if skill_parent.check_playable():
		current_mode = modes.IMBUE
		#skill_parent._update_description(skill_parent.actor_parent)
		transformed.emit()

func _on_imbue_action_ended():
	current_mode = modes.DRINK
	#skill_parent._update_description(skill_parent.actor_parent)
	reverted.emit()

func _on_skill_parent_attached_to_hotbar_slot(_slot : SkillHotbarSlot):
	transformed.connect(_slot.set_cycle_visibility.bind(true))
	transformed.connect(_slot.override_icon.bind(imbue_icon))
	transformed.connect(_slot.enable)
	reverted.connect(_slot.set_cycle_visibility.bind(false))
	reverted.connect(_slot.reset_icon)
	_slot.mid_action_button_clicked.connect(_on_slot_mid_action_button_clicked)
	imbue_confirmed.connect(_slot.disable)
	

func _on_skill_parent_removed_from_hotbar_slot(_slot : SkillHotbarSlot):
	if transformed.is_connected(_slot.set_cycle_visibility.bind(true)):
		transformed.disconnect(_slot.set_cycle_visibility.bind(true))
		transformed.disconnect(_slot.override_icon.bind(imbue_icon))
		transformed.disconnect(_slot.enable)
		reverted.disconnect(_slot.set_cycle_visibility.bind(false))
		reverted.disconnect(_slot.reset_icon)
		_slot.mid_action_button_clicked.disconnect(_on_slot_mid_action_button_clicked)
		imbue_confirmed.disconnect(_slot.disable)

func _on_slot_mid_action_button_clicked():
	imbue_confirmed.emit()
	pass
