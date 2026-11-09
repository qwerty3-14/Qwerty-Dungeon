extends Node

var dict : Dictionary[String, Skill]
var info_dict : Dictionary[String, SkillInfo]
var pckd_scene_dict : Dictionary[String, PackedScene]

var trees : Dictionary[String, PackedScene] = {
	"Infantry" : preload("uid://dsvd40sc2uphr"),
	"Arcanist" : preload("uid://dsjtrq83mgfj2"),
	"Fire Fighter" : preload("uid://d25glsjleekfg"),
	"Brewer" : preload("uid://criepepk81486"),
}


func _ready() -> void:
	print("Skill Library: ")
	load_for_info("res://SkillResources/SkillInfo/Actions/Basic Weapon Attacks/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Modified Weapon Attacks/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Martial Arts/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Alchemy/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Elder Magic/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Fire Magic/")
	load_for_info("res://SkillResources/SkillInfo/Actions/Meteorology/")
	load_for_info("res://SkillResources/SkillInfo/Passives/")
	load_for_info("res://SkillResources/SkillInfo/Reactions/")
	load_for_info("res://SkillResources/SkillInfo/Tests/")
	#load_folder("res://Skills/Actions/Weapon Attacks/")
	#load_folder("res://Skills/Actions/")
	#load_folder("res://Skills/Passives/")
	#load_folder("res://Skills/Reactions/")
	print("")

func load_folder(path : String):
	for file_name : String in ResourceLoader.list_directory(path):
		if file_name.ends_with(".tscn"):
			var pckd_scene : PackedScene = load(path + file_name)
			var skill : Skill = pckd_scene.instantiate()
			dict.get_or_add(skill.display_name, skill)
			add_child(skill)

func load_for_info(path : String):
	for file_name : String in ResourceLoader.list_directory(path):
		if file_name.ends_with(".tres"):
			var skill_info : SkillInfo = load(path + file_name)
			print(skill_info.display_name)
			info_dict.get_or_add(skill_info.display_name, skill_info)
			if skill_info.skill_path:
				pckd_scene_dict.get_or_add(skill_info.display_name, load(skill_info.skill_path))

func give_skill_to_actor(actor : Actor, library_key : String):
	var skill : Skill = pckd_scene_dict[library_key].instantiate()
	for i in range(24):
		if not actor.hotbar_skills.has(i):
			actor.hotbar_skills[i] = skill
			break
	skill.move_to_actor(actor)
