extends Node3D

class_name VerletCollisionSolver3D

var collisions := []
var vectors := []

var world_size := Vector2(1.0, 1.0)

var bias_index := 0
var biases := [Vector3(0.0001, 0.0001, 0.0001), Vector3(0.0001, 0.0001, -0.0001), Vector3(-0.0001, 0.0001, 0.0001), Vector3(-0.0001, 0.0001, -0.0001)]

func solve_collision_world_boundary(obj : VerletObject3D) -> void:
	if obj.position.y < 0.0:
		obj.position.y = 0.0
	if obj.position.x < -world_size.x:
		obj.position.x = -world_size.x
	elif obj.position.x > world_size.x:
		obj.position.x = world_size.x
	if obj.position.z < -world_size.y:
		obj.position.z = -world_size.y
	elif obj.position.z > world_size.y:
		obj.position.z = world_size.y

func solve_collision(object_a : VerletObject3D, object_b : VerletObject3D) -> void:
	if object_a.is_static and object_b.is_static:
		return
	
	if object_a.shape is SphereShape3D and object_b.shape is SphereShape3D:
		solve_collision_spheres(object_a, object_b, object_a.shape, object_b.shape)

func solve_collision_spheres(object_a : VerletObject3D, object_b : VerletObject3D, shape_a : SphereShape3D, shape_b : SphereShape3D) -> void:
	var collision : Vector3 = object_b.position - object_a.position
	var radius_squared_sum = shape_a.radius*shape_a.radius + shape_b.radius*shape_b.radius
	var distance_squared = collision.length_squared()
	if distance_squared <= radius_squared_sum:
		var bias = biases[bias_index]

		var n : float = distance_squared / radius_squared_sum
		if n < 0.9:
			n = 0.9
		var damping : float = (1.0 - n) * 0.75
		
		var radius = sqrt(radius_squared_sum)
		var ratio_a : float = float(shape_a.radius) / radius
		var ratio_b : float = float(shape_b.radius) / radius
		
		# Push the objects away from eachother
		object_a.position -= (collision * ratio_b) * damping + bias
		object_b.position += (collision * ratio_a) * damping

		#
		# Friction
		#
		
		object_a.friction = 0.98
		object_b.friction = 0.98
	
	bias_index += 1
	if bias_index >= biases.size():
		bias_index = 0

		
