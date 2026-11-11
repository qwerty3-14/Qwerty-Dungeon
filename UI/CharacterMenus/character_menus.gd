extends Control
class_name CharacterMenus

const SKILL_TREE_TAB := preload("uid://c62fqvi8mn8e")
const HOTBAR_SETUP_TAB := preload("uid://cnauogkji13df")


var actors : Array[Actor] = []
var combat_main : CombatMain
var is_between_battles : bool = false

func _ready() -> void:
	if PlayerStorage.players.size() == 0:
		PlayerStorage.emergency_load()
	add_actor(PlayerStorage.players[0].get_node("Actor"), 0)
	add_actor(PlayerStorage.players[1].get_node("Actor"), 1)
	add_actor(PlayerStorage.players[2].get_node("Actor"), 2)
	add_actor(PlayerStorage.players[3].get_node("Actor"), 3)
	RuneManager.set_rune_drag_container(%DraggedRuneContainer)
	RuneManager.set_rune_flow_container(%RuneFlow)
	#RuneLibrary.debug_generate_one_of_each()
	#RuneLibrary.debug_generate_one_of_each()


func add_actor(actor : Actor, index : int):
	actors.append(actor)
	var new_tree : SkillTree = SkillLibrary.trees[actor.combat_class].instantiate()
	new_tree.load_actor(actor)
	var new_tab : SkillTreeTab = SKILL_TREE_TAB.instantiate()
	new_tab.load_skill_tree(new_tree)
	new_tab.name = actor.character_name
	%"Skill Trees".add_child(new_tab)
	
	%BoardList.get_child(index).load_actor(actor)
	
	var new_setup_tab : HotbarSetupTab = HOTBAR_SETUP_TAB.instantiate()
	new_setup_tab.name = actor.character_name
	%Hotbars.add_child(new_setup_tab)
	new_setup_tab.load_actor(actor)
	#new_tree.load_actor(actor)

func set_between_battle_mode():
	is_between_battles = true
	%Blackout.visible = false
	%Exit.text = "Continue"
	for tree_tab : SkillTreeTab in  %"Skill Trees".get_children():
		tree_tab.give_point()

func set_middle_of_battle_mode():
	is_between_battles = false
	%Blackout.visible = true
	%Exit.text = "Return"

func _on_exit_pressed() -> void:
	if combat_main:
		if is_between_battles:
			combat_main.next_stage()
		combat_main.visible = true
		visible = false


func _on_rune_flow_mouse_entered() -> void:
	RuneManager.can_grab_from_inventory = true


func _on_rune_flow_mouse_exited() -> void:
	RuneManager.can_grab_from_inventory = false
