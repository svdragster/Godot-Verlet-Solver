extends Node3D

class_name VerletObject3D

var shape : Shape3D

var last_position : Vector3
var acceleration := Vector3.ZERO

@export var is_static : bool = false

func _ready() -> void:
	last_position = position

func update_position(new_position : Vector3) -> void:
	position = new_position
	last_position = new_position
	
func update(delta : float) -> void:
	push_error("Must be implemented by child")



