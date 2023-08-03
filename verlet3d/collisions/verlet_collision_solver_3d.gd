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
	elif object_a.shape is SphereShape3D and object_b.shape is BoxShape3D:
		# Sphere <-> Box
		solve_collision_sphere_box(object_a, object_b, object_a.shape, object_b.shape)
	elif object_a.shape is BoxShape3D and object_b.shape is SphereShape3D:
		# Box <-> Sphere
		solve_collision_sphere_box(object_b, object_a, object_b.shape, object_a.shape)

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
	
	# Invert basis rotation so we can check if the contact position is within the AABB of the plane
	var contact_position_inverted = Vector3(plane_local_contact_position)
	contact_position_inverted = plane.basis.inverse() * contact_position_inverted * plane.scale
	
	var aabb = AABB()
	var plane_scale = Vector3(plane.scale)
	plane_scale.y = 0.2
	aabb.position = plane.position + plane_scale
	aabb.end = plane.position - plane_scale
	aabb = aabb.abs()

	
	if not aabb.has_point(plane.position + contact_position_inverted):
		# We are outside of the planes bounds. Let's check for collisions with the edges of the plane
		
		#debug_draw.add_vector(plane.position, plane.position + contact_position_inverted, 4, Color.PURPLE, true)
		
		var edge_id := 0
		var edges := [
			[plane.position + plane.basis.x + plane.basis.z, plane.position + plane.basis.x - plane.basis.z], # positive x edge of plane
			[plane.position - plane.basis.x - plane.basis.z, plane.position - plane.basis.x + plane.basis.z], # negative x edge of plane
			[plane.position + plane.basis.z - plane.basis.x, plane.position + plane.basis.z + plane.basis.x], # positive z edge of plane
			[plane.position - plane.basis.z + plane.basis.x, plane.position - plane.basis.z - plane.basis.x], # negative z edge of plane
		]
		for edge in edges:
			var edge_a : Vector3 = edge[0]
			var edge_b : Vector3  = edge[1]
			var edge_vector : Vector3 = edge_b - edge_a
			var edge_length : float = edge_vector.length()
			var edge_direction : Vector3  = edge_vector / edge_length
			var edge_to_sphere : Vector3  = sphere.position - edge_a
			
			var edge_scale : float = edge_to_sphere.dot(edge_direction)
			#if plane.name == "VerletPlane3D2":
			#	print(edge_id, "\tedge_scale: ", edge_scale)
			if edge_scale > edge_length:
				edge_scale = edge_length
			elif edge_scale < 0.0:
				edge_scale = 0.0
			
			#debug_draw.add_vector(edge_a, edge_a + edge_direction * edge_scale, 4, Color.RED, true)
			
			var edge_scaled : Vector3 = (edge_a + edge_direction * edge_scale)
			
			var sphere_to_edge_contact : Vector3 = sphere.position - edge_scaled
			var sphere_to_edge_contact_distance : float = sphere_to_edge_contact.length_squared()
			var edge_contact_distance_squared : float = sphere_to_edge_contact_distance - sphere_shape.radius * sphere_shape.radius
			#if plane.name == "VerletPlane3D2":
			#	print(edge_id, "\tdistance: ", sqrt(abs(edge_contact_distance_squared)))
			if edge_contact_distance_squared <= 0:
				#debug_draw.add_vector(edge_a + edge_direction * edge_scale, sphere.position, 4, Color.RED, true)
				sphere.position += sphere_to_edge_contact.normalized() * sqrt(abs(edge_contact_distance_squared)) * 0.02
				sphere.friction = 0.98
			edge_id += 1
		
	else:
		# We are inside of the planes bounds. Check if the sphere is close enough to the plane
		
		#debug_draw.add_vector(plane.position, plane.position + contact_position_inverted, 4, Color.LIGHT_BLUE, true)
		
		var contact_distance_squared : float = contact_vector.length_squared() - sphere_shape.radius * sphere_shape.radius
		if contact_distance_squared <= 0:
			# Collision
			#debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.RED, true)
			sphere.position += plane_normal * sqrt(abs(contact_distance_squared)) * 0.02
			sphere.friction = 0.98
		else:
			# No collision
			pass
			#debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.GREEN, true)
	
	

func solve_collision_sphere_box(sphere : VerletObject3D, box : VerletObject3D, sphere_shape : SphereShape3D, box_shape : BoxShape3D) -> void:
	if not sphere.is_visible_in_tree():
		return
	var origin_to_sphere : Vector3 = sphere.position - box.position
	var faces : Array = [
		[box.basis.y/2, Basis(box.basis)],
		-box.basis.y/2,
		box.basis.x/2,
		-box.basis.x/2,
		box.basis.z/2,
		-box.basis.z/2,
	]
	var plane_basis_list : Array[Basis] = [
		Basis(box.basis.x, box.basis.y, box.basis.z),
		Basis(box.basis.x, -box.basis.y, box.basis.z),
		Basis(box.basis.y, box.basis.x, box.basis.z),
		Basis(box.basis.y, -box.basis.x, box.basis.z),
		Basis(box.basis.x, box.basis.z, box.basis.y),
		Basis(box.basis.x, -box.basis.z, box.basis.y),
	]
	var face_collision_success := false
	for plane_basis in plane_basis_list:
		var plane_offset = plane_basis.y/2
		var plane_position = box.position + plane_offset
		var plane_normal = plane_basis.y.normalized()
		var plane_x = plane_basis.x/2
		var plane_z = plane_basis.z/2
		var plane_to_sphere : Vector3 = sphere.position - (box.position + plane_offset)
		var sphere_distance_to_plane : float = plane_to_sphere.dot(plane_normal)
		
		if sphere_distance_to_plane < 0:
			continue
		
		var contact_vector : Vector3 = plane_normal * sphere_distance_to_plane
		var plane_contact_position : Vector3  = sphere.position - contact_vector
		var plane_contact_local_position : Vector3 = plane_contact_position - (box.position + plane_offset)
		
		var contact_x_scale = plane_x.dot(plane_contact_local_position) / plane_x.length()
		var contact_z_scale = plane_z.dot(plane_contact_local_position) / plane_z.length()
		var contact_x = plane_x.normalized() * contact_x_scale
		var contact_z = plane_z.normalized() * contact_z_scale
		
		
		if contact_x_scale*contact_x_scale > plane_x.length_squared():
			continue
		if contact_z_scale*contact_z_scale > plane_z.length_squared():
			continue
		
		debug_draw.add_vector(box.position + plane_offset, box.position + plane_offset + contact_z, 3, Color.GREEN_YELLOW, true)
		debug_draw.add_vector(box.position + plane_offset, box.position + plane_offset + contact_x, 3, Color.GREEN_YELLOW, true)
		
		debug_draw.add_vector(box.position + plane_offset, plane_contact_position, 2, Color.RED, true)
		debug_draw.add_vector(plane_contact_position, sphere.position, 2, Color.RED, true)
		
		#debug_draw.add_vector(box.position + plane_offset, box.position + plane_offset + plane_x, 2, Color.AQUA, true)
		#debug_draw.add_vector(box.position + plane_offset, box.position + plane_offset + plane_offset, 2, Color.BLUE, true)
		#debug_draw.add_vector(box.position + plane_offset, box.position + plane_offset + plane_z, 2, Color.AQUA, true)
		
		
		
#	for face in faces:
#		var face_offset = face[0]
#		var plane_position = box.position + face_offset
#		var plane_normal : Vector3 = face_offset.normalized()
#
#		var sphere_distance_to_plane : float = origin_to_sphere.dot(plane_normal)  
#
#		var contact_vector : Vector3  = plane_normal * sphere_distance_to_plane
#		var plane_contact_position : Vector3  = sphere.position - contact_vector
#
#		var plane_local_contact_position : Vector3 = plane_contact_position - plane_position
#
#		# Invert basis rotation so we can check if the contact position is within the AABB of the plane
#		var contact_position_inverted = Vector3(plane_local_contact_position)
#		contact_position_inverted = plane.basis.inverse() * contact_position_inverted * plane.scale
#
#		var aabb = AABB()
#		var plane_scale = Vector3(plane.scale)
#		plane_scale.y = 0.2
#		aabb.position = plane.position + plane_scale
#		aabb.end = plane.position - plane_scale
#		aabb = aabb.abs()
#
#		if aabb.has_point(plane.position + contact_position_inverted):
#			face_collision_success = true
#			var contact_distance_squared : float = contact_vector.length_squared() - sphere_shape.radius * sphere_shape.radius
#			if contact_distance_squared <= 0:
#				# Collision
#				#debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.RED, true)
#				sphere.position += plane_normal * sqrt(abs(contact_distance_squared)) * 0.02
#				sphere.friction = 0.98
#			else:
#				# No collision
#				pass
#				#debug_draw.add_vector(plane_contact_position, sphere.position, 4, Color.GREEN, true)
			
	
	if not face_collision_success:
		# We are outside of the planes bounds. Let's check for collisions with the edges of the plane
		
		#debug_draw.add_vector(plane.position, plane.position + contact_position_inverted, 4, Color.PURPLE, true)
		
		var edge_id := 0
		var edges := [
			#[plane.position + plane.basis.x + plane.basis.z, plane.position + plane.basis.x - plane.basis.z], # positive x edge of plane
			#[plane.position - plane.basis.x - plane.basis.z, plane.position - plane.basis.x + plane.basis.z], # negative x edge of plane
			#[plane.position + plane.basis.z - plane.basis.x, plane.position + plane.basis.z + plane.basis.x], # positive z edge of plane
			#[plane.position - plane.basis.z + plane.basis.x, plane.position - plane.basis.z - plane.basis.x], # negative z edge of plane
		]
		for edge in edges:
			var edge_a : Vector3 = edge[0]
			var edge_b : Vector3  = edge[1]
			var edge_vector : Vector3 = edge_b - edge_a
			var edge_length : float = edge_vector.length()
			var edge_direction : Vector3  = edge_vector / edge_length
			var edge_to_sphere : Vector3  = sphere.position - edge_a
			
			var edge_scale : float = edge_to_sphere.dot(edge_direction)
			#if plane.name == "VerletPlane3D2":
			#	print(edge_id, "\tedge_scale: ", edge_scale)
			if edge_scale > edge_length:
				edge_scale = edge_length
			elif edge_scale < 0.0:
				edge_scale = 0.0
			
			#debug_draw.add_vector(edge_a, edge_a + edge_direction * edge_scale, 4, Color.RED, true)
			
			var edge_scaled : Vector3 = (edge_a + edge_direction * edge_scale)
			
			var sphere_to_edge_contact : Vector3 = sphere.position - edge_scaled
			var sphere_to_edge_contact_distance : float = sphere_to_edge_contact.length_squared()
			var edge_contact_distance_squared : float = sphere_to_edge_contact_distance - sphere_shape.radius * sphere_shape.radius
			#if plane.name == "VerletPlane3D2":
			#	print(edge_id, "\tdistance: ", sqrt(abs(edge_contact_distance_squared)))
			if edge_contact_distance_squared <= 0:
				#debug_draw.add_vector(edge_a + edge_direction * edge_scale, sphere.position, 4, Color.RED, true)
				sphere.position += sphere_to_edge_contact.normalized() * sqrt(abs(edge_contact_distance_squared)) * 0.02
				sphere.friction = 0.98
			edge_id += 1

