extends VBoxContainer

func load_attribute(attribute : Attribute):
	%Sources.text = "Base: " + str(attribute.base_value)
	for bonus : AttrBonus in attribute.bonuses:
		if bonus.value != 0:
			%Sources.text += "\n"
			%Sources.text += bonus.source + ": " + str(bonus.value)
	%Total.text = "Total: " + str(attribute.value)
