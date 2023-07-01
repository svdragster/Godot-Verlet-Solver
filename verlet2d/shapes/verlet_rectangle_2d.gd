extends VerletObject2D

func set_size(x : int, y : int) -> void:
	var sprite_width = 128/2.0
	var sprite_height = 128/2.0
	$Sprite2D.scale = Vector2(x / sprite_width, y / sprite_height)
	shape = shape.duplicate()
	shape.size = Vector2(x, y)

func update(delta : float) -> void:
	# Velocity
	var velocity : Vector2 = (position - last_position) * friction
	var new_position : Vector2 = position + velocity + (acceleration*40) * (delta * delta)
	
	last_position = position
	position = new_position
	
	
	# Reset
	friction = 1.0
	acceleration = Vector2.ZERO
