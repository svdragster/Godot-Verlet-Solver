extends Node3D

class_name VerletCollisionSolver3D

var collisions := []
var vectors := []

var world_size := Vector2(10.0, 10.0)

var bias_index := 0
var biases := [Vector3(0.0001, 0.0001, 0.0001), Vector3(0.0001, 0.0001, -0.0001), Vector3(-0.0001, 0.0001, 0.0001), Vector3(-0.0001, 0.0001, -0.0001)]

func solve_collision_world_boundary(obj : VerletObject3D) -> void:
	if obj.position.y < -1.0:
		obj.position.y = -1.0
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
		# Sphere <-> Sphere
		solve_collision_spheres(object_a, object_b, object_a.shape, object_b.shape)
	elif object_a.shape is SphereShape3D and object_b.shape is BoxShape3D:
		# Sphere <-> Box
		solve_collision_sphere_box(object_a, object_b, object_a.shape, object_b.shape)
	elif object_a.shape is BoxShape3D and object_b.shape is SphereShape3D:
		# Box <-> Sphere
		solve_collision_sphere_box(object_b, object_a, object_b.shape, object_a.shape)
	elif object_a is VerletPlane3D and object_b.shape is SphereShape3D:
		# Plane <-> Sphere
		solve_collision_plane_sphere(object_a, object_b, object_b.shape)
	elif object_a.shape is SphereShape3D and object_b is VerletPlane3D:
		# Sphere <-> Plane
		solve_collision_plane_sphere(object_b, object_a, object_a.shape)

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
		
		var ratio_a : float = float(shape_a.radius * shape_a.radius) / radius_squared_sum
		var ratio_b : float = float(shape_b.radius * shape_b.radius) / radius_squared_sum
		
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
		
func solve_collision_plane_sphere(plane : VerletPlane3D, sphere : VerletSphere3D, sphere_shape : SphereShape3D) -> void:
	var origin_to_sphere : Vector3 = sphere.position - plane.position
	var plane_normal : Vector3 = plane.basis.y
	var normal_scale = origin_to_sphere.dot(plane_normal)
	# only check for collision when above plane
	if normal_scale >= 0.0:
		var plane_normal_scaled = plane_normal * normal_scale
		var plane_normal_scaled_length = plane_normal_scaled.length()
		var radius_squared = sphere_shape.radius * sphere_shape.radius
		var diff = plane_normal_scaled_length - radius_squared
		if diff <= 0:
			print(abs(diff))
			sphere.position += plane_normal * abs(diff) * 0.01
	#var collision_vector = (sphere.position - plane_normal_scaled)
	#print("collision_vector: ", collision_vector, "  plane_normal_scaled: ", plane_normal_scaled)
	#var plane_rotation : Vector3 = Vector3(1, 0, 1)
	#var angle : float = origin_to_sphere.angle_to(plane_rotation)
	#var alpha := 2.0*PI - ((PI/2.0) + angle)
	
	#var b = cos(alpha) * origin_to_sphere
	#print("origin_to_sphere: ", origin_to_sphere, "   angle: ", angle, "  b: ", b)
	

func solve_collision_sphere_box(object_sphere : VerletObject3D, object_box : VerletObject3D, sphere : SphereShape3D, box : BoxShape3D) -> void:
	var box_vertices_offsets = [
		Vector3(-1, -1, -1),
		Vector3(-1, -1,  1),
		Vector3(-1,  1, -1),
		Vector3(-1,  1,  1),
		Vector3( 1, -1, -1),
		Vector3( 1, -1,  1),
		Vector3( 1,  1, -1),
		Vector3( 1,  1,  1),
	]
	for vertex_offset in box_vertices_offsets:
		var size_adjusted_offset = vertex_offset * box.size
