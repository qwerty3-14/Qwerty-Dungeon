extends Node
class_name APSpender

signal ap_spent(amount : int)

@export var ap_cost : int

func _init() -> void:
	ready.connect(_on_ready)

func spend_ap():
	ap_spent.emit(ap_cost)

func _on_ready():
	if get_parent() is Skill:
		get_parent().need_info_panel_extras.connect(_on_need_info_panel_extras)
		get_parent().aquired_by_actor.connect(_on_spender_parent_aquired_by_actor)

func _on_spender_parent_aquired_by_actor(actor : Actor):
	ap_spent.connect(actor.spend_ap)

func _on_need_info_panel_extras(info_panel : InfoPanel):
	info_panel.load_ap(self)
