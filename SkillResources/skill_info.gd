extends Resource
class_name SkillInfo

enum skill_types {
	PASSIVE,
	ACTION,
	REACTION
}

@export_category("Skill Info")
@export var icon : Texture2D
@export var display_name : String
@export_multiline var description : String
@export var skill_type : skill_types

@export_category("Range Info")
@export var target_range : float = 0
@export var min_target_range : float = 0
@export var aoe : float = 0

@export_category("Action Info")
@export var ap_cost : int = 0
@export var action_cooldown : int = 0
@export var action_type : Action.types


@export_category("Misc")
@export var skill_path : String
