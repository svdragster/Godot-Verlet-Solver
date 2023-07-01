
class_name VerletCollisionSolver2D

func solve_collision(object_a : VerletObject2D, object_b : VerletObject2D):
	var collision : Vector2 = object_b.position - object_a.position
	
	if object_a.shape is CircleShape2D and object_b.shape is CircleShape2D:
		solve_circle_circle_collision(collision, object_a, object_b, object_a.shape, object_b.shape)
		
	if object_a.shape is RectangleShape2D and object_b.shape is RectangleShape2D:
		solve_rect_rect_collision(collision, object_a, object_b, object_a.shape, object_b.shape)
		
			
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
		object_a.friction = 0.99
		object_b.friction = 0.99

func solve_rect_rect_collision(collision : Vector2, object_a : VerletObject2D, object_b : VerletObject2D, shape_a : RectangleShape2D, shape_b : RectangleShape2D) -> void:
	pass
