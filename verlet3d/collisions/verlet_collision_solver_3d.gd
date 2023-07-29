extends Node3D

class_name VerletCollisionSolver3D

var debug_draw

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
	var radius_sum : float = (shape_a.radius + shape_b.radius)
	if collision.length_squared() <= radius_sum * radius_sum:
		var distance : float = collision.length()
		var bias : Vector3 = biases[bias_index]

		var n : float = distance / radius_sum
		if n < 0.9:
			n = 0.9
		var damping : float = (1.0 - n) * 0.2
		if damping < 0.0:
			damping = 0.0
		
		var ratio_a : float = shape_a.radius / radius_sum
		var ratio_b : float = shape_b.radius / radius_sum
		
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
	var plane_normal : Vector3 = plane.basis.y.normalized()
	
	var sphere_distance_to_plane : float = origin_to_sphere.dot(plane_normal)  
	
	var contact_vector : Vector3  = plane_normal * sphere_distance_to_plane
	var plane_contact_position : Vector3  = sphere.position - contact_vector
	
	var plane_local_contact_position : Vector3 = plane_contact_position - plane.position
	
	if abs(plane_local_contact_position.x) > plane.scale.x or abs(plane_local_contact_position.z) > plane.scale.z:
		# We are outside of the planes bounds. Let's check for collisions with the edges of the plane
		
		var edges = [
			[plane.position + plane.basis.x + plane.basis.z, plane.position + plane.basis.x - plane.basis.z], # positive x edge of plane
			[plane.position - plane.basis.x - plane.basis.z, plane.position - plane.basis.x + plane.basis.z], # negative x edge of plane
			[plane.position + plane.basis.z - plane.basis.x, plane.position + plane.basis.z + plane.basis.x], # positive z edge of plane
			[plane.position - plane.basis.z + plane.basis.x, plane.position - plane.basis.z - plane.basis.x], # negative z edge of plane
		]
		for edge in edges:
			var edge_a : Vector3 = edge[0]
			var edge_b : Vector3  = edge[1]
			var edge_direction : Vector3  = (edge_b - edge_a).normalized()
			var edge_to_sphere : Vector3  = sphere.position - edge_a
			
			var edge_scale : float = edge_to_sphere.dot(edge_direction)
			debug_draw.add_vector(edge_a, edge_a + edge_direction * edge_scale, 4, Color.RED, true)
			
			var edge_scaled : Vector3 = (edge_a + edge_direction * edge_scale)
			
			var sphere_to_edge_contact : Vector3 = sphere.position - edge_scaled
			var sphere_to_edge_contact_distance : float = sphere_to_edge_contact.length_squared()
			var edge_contact_distance_squared : float = sphere_to_edge_contact_distance - sphere_shape.radius * sphere_shape.radius
			if edge_contact_distance_squared <= 0:
				debug_draw.add_vector(edge_a + edge_direction * edge_scale, sphere.position, 4, Color.RED, true)
				sphere.position += sphere_to_edge_contact.normalized() * sqrt(abs(edge_contact_distance_squared)) * 0.02
				sphere.friction = 0.98
		
	else:
		# We are inside of the planes bounds. Check if the sphere is close enough to the plane
		var contact_distance_squared : float = contact_vector.length_squared() - sphere_shape.radius * sphere_shape.radius
		if contact_distance_squared <= 0:
			# Collision
			debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.RED, true)
			sphere.position += plane_normal * sqrt(abs(contact_distance_squared)) * 0.02
			sphere.friction = 0.98
		else:
			# No collision
			pass
			debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.GREEN, true)
	
	

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
