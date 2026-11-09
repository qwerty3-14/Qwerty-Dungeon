extends Node2D
class_name ImpalementBlades

const VEL_VECTORS : Array[Vector2] = [Vector2(-1, 0), Vector2(-0.7, -0.7), Vector2(-0, -1), Vector2(0.7, -0.7),Vector2(1, 0)]

var damage : Damage

@export var anim_curce : Curve
@export var target : CombatObject
@export var blade_count : int = 5

func _ready() -> void:
	match blade_count:
		1:
			%UpBlade.visible = true
		2:
			%UpLeftBlade.visible = true
			%UpRightBlade.visible = true
		3:
			%UpBlade.visible = true
			%UpLeftBlade.visible = true
			%UpRightBlade.visible = true
		4:
			%UpLeftBlade.visible = true
			%UpRightBlade.visible = true
			%LeftBlade.visible = true
			%RightBlade.visible = true
		5:
			%UpBlade.visible = true
			%UpLeftBlade.visible = true
			%UpRightBlade.visible = true
			%LeftBlade.visible = true
			%RightBlade.visible = true

func _process(_delta: float) -> void:
	var prog : float = anim_curce.sample(1 - (%AnimTimer.time_left / %AnimTimer.wait_time))
	if prog > 0:
		pass
	else:
		%UpLeftBlade.frame = 2
		%UpLeftBlade.flip_h = false
		%UpRightBlade.frame = 2
		%UpRightBlade.flip_h = true
		%UpBlade.frame = 4
		position = Globals.tile_to_pix_pos(target.tile_position)
	for index : int in range(5):
		var pos : Vector2 = VEL_VECTORS[index] * prog * 16 * 20
		pos.y = abs(pos.y) * -1
		get_child(index).position = pos


func _on_anim_timer_timeout() -> void:
	for _i : int in range(blade_count):
		var dmg : Damage = damage.clone()
		target.receive_damage(dmg)
	for index : int in range(5):
		get_child(index).self_modulate = Color.TRANSPARENT
		get_child(index).get_child(0).emitting = false
	%DecayTimer.start()


func _on_decay_timer_timeout() -> void:
	queue_free()
