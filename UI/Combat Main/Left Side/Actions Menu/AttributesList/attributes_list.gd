extends VBoxContainer
class_name AttributesList


var actor : Actor

func _ready() -> void:
	%MGTSign.hovered.connect(_on_sign_hovered.bind("Might", "Increases damage with weapon attacks.\nNegates enemy resilience when applying status effects with weapon attacks."))
	%POTSign.hovered.connect(_on_sign_hovered.bind("Potency", "Makes spells more powerful\nNegates enemy resilience when applying status effects with spells"))
	%CONSign.hovered.connect(_on_sign_hovered.bind("Constitution", "Increases max health by 3 per point.\nEach odd point increases max ap by 1"))
	%RESSign.hovered.connect(_on_sign_hovered.bind("Resilience", "Protects against enemy status effects.\nHeal 3 hp per point at the start of combat"))
	%INTSign.hovered.connect(_on_sign_hovered.bind("Intelligence", "Increases Initiative by 1 for each point"))
	%SPDSign.hovered.connect(_on_sign_hovered.bind("Speed", "Increases phase and max mp by 1 for every odd point.\nIncreases Initiative by 1 for each even point"))
	%LCKSign.hovered.connect(_on_sign_hovered.bind("Luck", "Increases hit chance by 3% for each point.\nIncreases dodge chance by 3% for each point\nIncreases the chance of chance based skills triggering"))


func load_actor(new_actor : Actor):
	#clear old data
	if actor:
		pass
	
	actor = new_actor
	#attributes
	
	#%MGTValue.text = actor.might.colored_text()
	%MGTSign.load_attribute(actor.might)
	%POTSign.load_attribute(actor.potency)
	%CONSign.load_attribute(actor.constitution)
	%RESSign.load_attribute(actor.resilience)
	%INTSign.load_attribute(actor.intelligence)
	%SPDSign.load_attribute(actor.speed)
	%LCKSign.load_attribute(actor.luck)
	
func _on_sign_hovered(title : String, desc : String):
	Globals.over_room_renders.set_desc_info_panel(title, desc)

func _on_mouse_exited() -> void:
	Globals.over_room_renders.hide_skill_info_panel()
