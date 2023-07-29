extends Node3D

class_name VerletSolver3D

@export var substeps : int = 8
@export var gravity := Vector3(0.0, -10.0, 0.0)


var collision_solver := VerletCollisionSolver3D.new()
var constraint_list := []

func _ready() -> void:
	collision_solver.debug_draw = get_node("/root/Example3D_1/DebugCamera3D/DebugDraw")
	set_physics_process(true)

func _physics_process(delta : float) -> void:
	var sub_delta : float = delta / substeps
	for i in range(substeps):
		update_collisions(sub_delta)
		update_constraints(sub_delta)
	update_objects(delta)	


func update_objects(delta : float) -> void:
	for child in get_children():
		child.acceleration += gravity
		child.update(delta)

func update_constraints(delta : float) -> void:
	for c in constraint_list:
		c.update_constraint(delta)

func update_collisions(delta : float) -> void:
	for i in range(get_child_count()):
		var child_a : VerletObject3D = get_child(i)
		for k in range(i+1, get_child_count()):
			var child_b : VerletObject3D = get_child(k)
			
			collision_solver.solve_collision(child_a, child_b)
		collision_solver.solve_collision_world_boundary(child_a)
			
#func add_constraint(c : VerletConstraint3D) -> void:
#	constraint_list.append(c)
