extends Resource
class_name ForecastLine

@export var chance : int = -1
@export var damage_instances : Array[Damage] = []
@export var status_icons : Array[Texture2D] = []
@export var repeats : int = 0

func print() -> String:
	var first : bool = true
	var out_string : String = ""
	if damage_instances.size() > 0:
		if first:
			first = false
		else:
			out_string += " "
		for i : int in range(damage_instances.size()):
			out_string += damage_instances[i].colored_number()
			if i < damage_instances.size() - 1:
				out_string += "+"
	if status_icons.size() > 0:
		if first:
			first = false
		else:
			out_string += " "
		for i : int in range(status_icons.size()):
			out_string += "[img]" + status_icons[i].resource_path +"[/img]"
	if chance != -1:
		out_string += " : " + str(chance) + "%"
	if repeats > 0:
		out_string += " "
		out_string += "[color=821d30][tornado radius=2.0 freq=-8.0 connected=1]x" +str(repeats + 1)+ "[/tornado][/color]"
	return out_string
