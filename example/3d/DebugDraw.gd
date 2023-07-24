extends Control

@onready var camera : Camera3D = get_parent()
var debug_vectors : Array = []

class Vector:
	var from : Vector3
	var to : Vector3
	var width  # Line width
	var color  # Draw color
	
	func _init(_from, _to, _width, _color):
		from = _from
		to = _to
		width = _width
		color = _color

	func draw(node, camera):
		var start = camera.unproject_position(from)
		var end = camera.unproject_position(to)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)

class VectorObject:
	var object  # The node to follow
	var property  # The property to draw
	var scale  # Scale factor
	var width  # Line width
	var color  # Draw color

	func _init(_object, _property, _scale, _width, _color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color

	func draw(node, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)

func _process(delta):
	queue_redraw()

func _draw():
	for vector in debug_vectors:
		vector.draw(self, camera)

func draw_triangle(pos, dir, size, color):
	var a = pos + dir * size
	var b = pos + dir.rotated(2*PI/3) * size
	var c = pos + dir.rotated(4*PI/3) * size
	var points = PackedVector2Array([a, b, c])
	draw_polygon(points, PackedColorArray([color]))

func add_vector(from, to, width, color):
	debug_vectors.append(Vector.new(from, to, width, color))
	
func add_vector_object(object, property, scale, width, color):
	debug_vectors.append(VectorObject.new(object, property, scale, width, color))
