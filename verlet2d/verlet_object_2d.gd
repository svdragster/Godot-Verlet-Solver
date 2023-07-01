@tool
extends Node2D

class_name VerletObject2D

var shape : Shape2D

var last_position : Vector2
var acceleration : Vector2 = Vector2.ZERO

var last_rotation : float = 0.0
var angular_acceleration : float = 0.0

var friction := 1.0



func _ready() -> void:
	last_position = position
	last_rotation = rotation

func update_position(new_position : Vector2) -> void:
	position = new_position
	last_position = new_position
	
func update(delta : float) -> void:
	# Velocity
	var velocity : Vector2 = (position - last_position) * friction
	var new_position : Vector2 = position + velocity + (acceleration*40) * (delta * delta)
	
	last_position = position
	position = new_position
	
	acceleration = Vector2.ZERO
	
	
	# Rotation
	angular_acceleration = velocity.x
	var angular_velocity : float = (rotation - last_rotation) * friction
	if abs(angular_velocity) < 0.0001:
		angular_velocity = 0.0
	var new_rotation = rotation + angular_velocity + (angular_acceleration*40) * (delta * delta)
	
	last_rotation = rotation
	rotation = new_rotation
	
	angular_acceleration = 0.0
	
	# Reset friction
	friction = 1.0


func solve_collision(other : VerletObject2D):
	var collision : Vector2 = other.position - position
	
	if shape is CircleShape2D and other.shape is CircleShape2D:
		solve_circle_circle_collision(collision, self, other, self.shape, other.shape)
		
			
func solve_circle_circle_collision(collision : Vector2, object_a : VerletObject2D, object_b : VerletObject2D, shape_a : CircleShape2D, shape_b : CircleShape2D) -> void:
	var radius = shape_a.radius + shape_b.radius
	var distance_squared = collision.length_squared()
	if distance_squared < radius*radius:
		var n : float = sqrt(distance_squared) / (radius)
		if n < 0.9:
			n = 0.9
		var damping : float = (1.0 - n) * 0.75
		var bias := Vector2(0.00001, 0.000001)
		object_a.position -= collision * damping + bias
		object_b.position += collision * damping
		object_a.friction = 0.99
		object_b.friction = 0.99
