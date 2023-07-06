extends VerletObject2D

var last_rotation : float = 0.0
var angular_acceleration : float = 0.0

var sleeping_position := 20
var sleeping_rotation := false

var friction : float = 1.0

func _ready():
	super._ready()
	set_size(scale.x * 64.0, scale.y * 64.0)

func set_size(x : int, y : int) -> void:
	var sprite_width = 128.0
	var sprite_height = 128.0
	$Sprite2D.scale = Vector2(x / sprite_width, y / sprite_height)
	shape = shape.duplicate()
	shape.size = Vector2(x, y)

func update(delta : float) -> void:
	if not is_static:
		# Velocity
		var velocity : Vector2 = (position - last_position) * friction
		if velocity.length_squared() < 0.01*0.01:
			if sleeping_position > 1:
				sleeping_position -= 1
			else:
				last_position = position
			pass
		else:
			sleeping_position = 20
				
		if sleeping_position > 1:
			var new_position : Vector2 = position + velocity + (acceleration*40) * (delta * delta)
			
			last_position = position
			position = new_position
		
		# Rotation
		update_rotation(delta)
		
		angular_acceleration = 0.0
		
		# Reset
		friction = 1.0
		acceleration = Vector2.ZERO
	
	
func update_rotation(delta : float):
	var angular_velocity : float = (rotation - last_rotation)
	if abs(angular_velocity) < 0.005:
		angular_velocity = 0.0
		last_rotation = rotation
	var new_rotation = rotation + angular_velocity + (angular_acceleration) * (delta * delta)
	
	last_rotation = rotation
	rotation = new_rotation
