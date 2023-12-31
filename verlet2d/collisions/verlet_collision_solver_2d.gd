extends Node2D

class_name VerletCollisionSolver2D

var collisions := []
var vectors := []

func solve_collision(object_a : VerletObject2D, object_b : VerletObject2D):
	var collision : Vector2 = object_b.position - object_a.position
	
	solve_collision_shapes(object_a, object_b, object_a.shape, object_b.shape)
	
	#if object_a.shape is CircleShape2D and object_b.shape is CircleShape2D:
	#	solve_circle_circle_collision(collision, object_a, object_b, object_a.shape, object_b.shape)
		
	#if object_a.shape is RectangleShape2D and object_b.shape is RectangleShape2D:
	#	solve_rect_rect_collision(collision, object_a, object_b, object_a.shape, object_b.shape)
		
			
func solve_circle_circle_collision(collision : Vector2, object_a : VerletObject2D, object_b : VerletObject2D, shape_a : CircleShape2D, shape_b : CircleShape2D) -> void:
	var radius : int = shape_a.radius + shape_b.radius
	
	var distance_squared = collision.length_squared()
	if distance_squared < radius*radius:
		# Calculate the force with how much they should push eachother away.
		# If they barely overlap, the force will be very small
		var n : float = sqrt(distance_squared) / (radius)
		if n < 0.9:
			n = 0.9
		var damping : float = (1.0 - n) * 0.75
		
		# Add a very small bias in case the positions are exactly the same
		var bias := Vector2(0.00001, 0.000001) 
		
		var ratio_a : float = float(shape_a.radius) / radius
		var ratio_b : float = float(shape_b.radius) / radius
		
		# Push the objects away from eachother
		object_a.position -= (collision * ratio_b) * damping + bias
		object_b.position += (collision * ratio_a) * damping

func solve_collision_shapes(object_a : VerletObject2D, object_b : VerletObject2D, shape_a : Shape2D, shape_b : Shape2D) -> void:
	if object_a.is_static and object_b.is_static:
		return
	var contacts := shape_a.collide_and_get_contacts(object_a.transform, shape_b, object_b.transform)
	var contact_amount = contacts.size() / 2
	if contact_amount >= 1:
		for i in range(0, contacts.size(), 2):
			var contact_a : Vector2 = contacts[i]
			var contact_b : Vector2 = contacts[i+1]
			collisions.append_array([[contact_a, Color.RED], [contact_b, Color.DARK_RED]])
			var contact_vector : Vector2 = contact_b - contact_a
			var collision_normal : Vector2 = contact_vector.normalized()
			var collision_depth : float = contact_vector.length()
			
			var center_of_mass_a = object_a.position
			var center_of_mass_b = object_b.position
			var collision_arm_a = contact_a - center_of_mass_a
			var collision_arm_b = contact_b - center_of_mass_b
			
			collisions.append_array([[center_of_mass_a, Color.RED], [center_of_mass_b, Color.DARK_RED]])
			
			vectors.append([center_of_mass_a, contact_a, Color.DARK_GREEN])
			vectors.append([center_of_mass_b, contact_b, Color.GREEN])
			vectors.append([contact_b, contact_a, Color.ORANGE])
			
			#var angle_a = -(collision_arm_a.angle() - object_a.rotation)
			#var angle_b = -(collision_arm_b.angle() - object_b.rotation)
			
			var torque_a = -collision_normal.cross(collision_arm_a) / contact_amount
			var torque_b = collision_normal.cross(collision_arm_b) / contact_amount
			
			object_a.angular_acceleration += torque_a * 0.2
			object_b.angular_acceleration += torque_b * 0.2
			
			
			# Add a very small bias in case the positions are exactly the same
			var bias := Vector2(0.00001, 0.000001) 
			var damping : float = 0.2
			
			# Push the objects away from eachother
			if not object_a.is_static:
				object_a.position += (contact_vector) * damping + bias
			if not object_b.is_static:
				object_b.position -= (contact_vector) * damping
			
			#
			# Friction
			#
			
			object_a.friction = 0.96
			object_b.friction = 0.96
			
#			var velocity_a = object_a.position - object_a.last_position
#			var velocity_b = object_b.position - object_b.last_position
#
#			var tangent_a = (velocity_a - velocity_a.dot(collision_normal) * collision_normal).normalized() * 0.995
#			var tangent_b = (velocity_b - velocity_b.dot(collision_normal) * collision_normal).normalized() * 0.995
#
#			vectors.append([center_of_mass_a, center_of_mass_a + (tangent_a * 20), Color.GOLDENROD])
#			vectors.append([center_of_mass_b, center_of_mass_b + (tangent_b * 20), Color.DARK_GOLDENROD])
			
			#object_a.friction = tangent_a
			#object_b.friction = tangent_b
			
		
