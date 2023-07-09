extends VerletConstraint2D

class_name VerletChainConstraint2D

var object_a : Node2D
var object_b : Node2D
var length : float
var _length_squared : float

var max_difference : float = 0.1

func _init(object_a : Node2D, object_b : Node2D, length : float):
	self.object_a = object_a
	self.object_b = object_b
	self.length = length
	_length_squared = length * length
	
func update_constraint(delta : float) -> void:
	var v : Vector2 = object_b.position - object_a.position
	var actual_length_squared : float = v.length_squared()
	#print(sqrt(actual_length_squared), " ", sqrt(actual_length_squared) - sqrt(_length_squared))
	var distance : float = actual_length_squared - _length_squared
	if distance > max_difference:
		var damping := 100.0
		if distance < 5.0*5.0:
			damping = 200.0
		if not object_a.is_static:
			object_a.position += v/damping
		if not object_b.is_static:
			object_b.position += v/-damping
