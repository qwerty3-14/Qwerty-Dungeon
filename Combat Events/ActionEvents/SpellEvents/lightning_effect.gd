extends Node2D

@export var end_pos : Vector2

var points : Array[Vector2] = []
var forks : Dictionary[int, Vector2]

func _process(_delta: float) -> void:
	if not %Timer.is_stopped():
		queue_redraw()

func _draw() -> void:
	var dist : float = end_pos.length()
	var angle : float = end_pos.angle()
	var progress : float = min((1 - %Timer.time_left / %Timer.wait_time) * 2, 1)
	var prev_pont : Vector2 = Vector2.ZERO
	for i : int in range(points.size()):
		var point : Vector2 = points[i]
		if (cos(point.angle() - angle) * point.length()) / dist > progress:
			break
		draw_line(prev_pont, point, Color.YELLOW, 2)
		draw_line(prev_pont, point, Color(Color.YELLOW, 0.4), 4)
		if forks.has(i):
			draw_line(point, forks[i], Color.YELLOW, 1)
			draw_line(point, forks[i], Color(Color.YELLOW, 0.4), 2)
			
		prev_pont = point

func activate():
	generate()
	queue_redraw()
	%Timer.start()
	

func generate():
	points.clear()
	forks.clear()
	var dist : float = end_pos.length()
	var angle : float = end_pos.angle()
	var travel : float = 0
	var prev : Vector2 = Vector2.ZERO
	while travel < dist:
		travel += Globals.rng.randf() * 4 + 10
		var rand_off : float = (Globals.rng.randf() - 0.5) * 16
		if travel > dist:
			travel = dist
			rand_off = 0
		var prog_point : Vector2 = Vector2.from_angle(angle) * travel
		var perp_offset : Vector2 = Vector2.from_angle(angle + PI * 0.5) * rand_off
		points.append(prog_point + perp_offset)
		if travel < dist and Globals.rng.randi_range(0, 2) == 0:
			var fork_angle : float = (points.back() - prev).angle() + (Globals.rng.randf() - 0.5) * PI * 0.25
			forks[points.size() - 1] = points.back() + Vector2.from_angle(fork_angle) * (Globals.rng.randf() * 4 + 7)
		prev = points.back()
	

func _on_timer_timeout() -> void:
	queue_free()
