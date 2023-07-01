@tool
extends Node2D

class_name VerletCollision2D

@export var shape : Shape2D:
	set(new_value):
		if shape == new_value:
			return

		if shape != null and shape.changed.is_connected(queue_redraw):
			shape.changed.disconnect(queue_redraw)

		shape = new_value
		if shape != null and not shape.changed.is_connected(queue_redraw):
			shape.changed.connect(queue_redraw)

		queue_redraw()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		get_parent().shape = self.shape
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		if shape:
			shape.draw(get_canvas_item(), Color(Color.BLUE, 0.3))
