extends Node2D

class_name VerletObject2D

var shape : Shape2D

var last_position : Vector2
var acceleration : Vector2 = Vector2.ZERO


var friction := 1.0

func _ready() -> void:
	last_position = position

func update_position(new_position : Vector2) -> void:
	position = new_position
	last_position = new_position
	
func update(delta : float) -> void:
	push_error("Must be implemented by child")



