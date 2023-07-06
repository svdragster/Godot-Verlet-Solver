extends Node2D

class_name VerletSolver2D

@export var substeps : int = 8
@export var gravity : Vector2 = Vector2(0.0, 30.0)

var world_size := Vector2(400, 250)
var margin := 2.0

var collision_solver := VerletCollisionSolver2D.new()

var draw_debug := true

func _ready() -> void:
	set_physics_process(true)

func _process(delta):
	if draw_debug:
		queue_redraw()

func _draw():
	for v in collision_solver.vectors:
		draw_line(v[0], v[1], Color(v[2], 0.3), 2.0)
	for c in collision_solver.collisions:
		draw_rect(Rect2(c[0] - Vector2(3, 3), Vector2(6, 6)), Color(c[1], 0.3), true)

func _physics_process(delta : float) -> void:
	collision_solver.collisions.clear()
	collision_solver.vectors.clear()
	var sub_delta : float = delta / substeps
	for i in range(substeps):
		check_collisions(sub_delta)
	update_objects(delta)	


func update_objects(delta : float) -> void:
	for child in get_children():
		child.acceleration += gravity
		child.update(delta)
		
		# map border collision
#		if child.position.x > world_size.x - margin:
#			child.position.x = world_size.x - margin
#		elif child.position.x < -world_size.x - margin:
#			child.position.x = -world_size.x - margin
#
#		if child.position.y > world_size.y - margin:
#			child.position.y = world_size.y - margin
#		elif child.position.y < -world_size.y - margin:
#			child.position.y = -world_size.y - margin

func check_collisions(delta : float) -> void:
	for i in range(get_child_count()):
		var child_a : VerletObject2D = get_child(i)
		for k in range(i+1, get_child_count()):
			var child_b : VerletObject2D = get_child(k)
			
			collision_solver.solve_collision(child_a, child_b)
			
			
		
