extends VerletConstraint2D

class_name VerletSpringConstraint2D

var parent : Node2D
var child : Node2D
var offset : Vector2
var spring_strength : Vector2

var max_difference : float = 0.01

func _init(parent : Node2D, child : Node2D, offset : Vector2, spring_strength : Vector2):
	self.parent = parent
	self.child = child
	self.offset = offset
	self.spring_strength = spring_strength
	
func update_constraint(delta : float) -> void:
	var v = (parent.position + offset) - child.position
	if v.length_squared() > max_difference:
		if not child.is_static:
			v *= spring_strength
			child.position += v
