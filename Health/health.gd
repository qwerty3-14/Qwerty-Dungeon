@icon("uid://rdoh57xw2iae")
extends Node
class_name Health
## Add health to a node, the node will be killed when it runs out


signal health_changed(health: int)
signal damage_recieved(amount: int)
signal heal_recieved(amount: int)
signal killed()
signal topped_off()
signal no_longer_max()
signal about_to_take_damage(amount: int)

## Max health
@export var maximum : int = 30

var current : int = 0

func _ready():
	current = maximum
	health_changed.emit(current)


func take_damage(amount : int):
	#don't take damage if you're already dead
	if current <= 0:
		return
	about_to_take_damage.emit(amount)
	damage_recieved.emit(amount)
	if(maximum == -1):
		return
	if(current >= maximum and amount > 0):
		no_longer_max.emit()
	current -= amount
	if current < 0:
		current = 0
	health_changed.emit(current)
	if current == 0:
		#get_parent().queue_free()
		killed.emit()


func heal(amount : int):
	heal_recieved.emit(amount)
	if(maximum == -1):
		return
	current += amount
	if current >= maximum:
		current = maximum
		topped_off.emit()
	health_changed.emit(current)
