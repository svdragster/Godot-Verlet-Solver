extends VerletConstraint2D

class_name VerletOffsetConstraint2D

var parent : Node2D
var child : Node2D
var offset : Vector2

var max_difference : float = 1.0

func _init(parent : Node2D, child : Node2D, offset : Vector2):
	self.parent = parent
	self.child = child
	self.offset = offset
	
func update_constraint(delta : float) -> void:
	var v = child.position - (parent.position + offset)
	if v.length_squared() > max_difference:
		if not child.is_static:
			child.position = (parent.position + offset)
