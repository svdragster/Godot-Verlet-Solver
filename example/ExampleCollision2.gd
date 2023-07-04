extends Node2D

var movement_vector := Vector2(0, 0)
@onready var controlled_entity := $VerletSolver2D.get_node("VerletCircle2D")

@onready var stuck_entity := $VerletSolver2D.get_node("VerletRectangle2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("up"):
		movement_vector.y = -1
	elif Input.is_action_pressed("down"):
		movement_vector.y = 1
	else:
		movement_vector.y = 0
		
	if Input.is_action_pressed("left"):
		movement_vector.x = -1
	elif Input.is_action_pressed("right"):
		movement_vector.x = 1
	else:
		movement_vector.x = 0
		
	if Input.is_action_pressed("reset"):
		controlled_entity.acceleration = Vector2(0, 0)
		stuck_entity.rotation = 0
		stuck_entity.last_rotation = 0
	
	controlled_entity.acceleration = movement_vector * 10.0
	
	stuck_entity.position = Vector2(0, 0)
