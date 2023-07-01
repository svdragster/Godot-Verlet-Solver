extends Node

class_name VerletSolver2D

@export var substeps : int = 8
@export var gravity : Vector2 = Vector2(0.0, 30.0)

var world_size := Vector2(200, 200)
var margin := 2.0

func _ready() -> void:
	set_physics_process(true)



func _physics_process(delta : float) -> void:
	var sub_delta : float = delta / substeps
	for i in range(substeps):
		check_collisions(sub_delta)
		update_objects(sub_delta)	


func update_objects(delta : float) -> void:
	for child in get_children():
		child.acceleration += gravity
		child.update(delta)
		
		# map border collision
		if child.position.x > world_size.x - margin:
			child.position.x = world_size.x - margin
			child.friction = 0.99
		elif child.position.x < -world_size.x - margin:
			child.position.x = -world_size.x - margin
			child.friction = 0.99
			
		if child.position.y > world_size.y - margin:
			child.position.y = world_size.y - margin
			child.friction = 0.99
		elif child.position.y < -world_size.y - margin:
			child.position.y = -world_size.y - margin
			child.friction = 0.99

func check_collisions(delta : float) -> void:
	for i in range(get_child_count()):
		var child_a : VerletObject2D = get_child(i)
		for k in range(i+1, get_child_count()):
			var child_b : VerletObject2D = get_child(k)
			
			child_a.solve_collision(child_b)
			
			
		
