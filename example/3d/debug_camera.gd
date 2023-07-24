extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("cam_move"):
		var factor = (4 if Input.is_action_pressed("cam_fast") else 2) * delta
		if Input.is_action_pressed("cam_forward"):
			position += Vector3.FORWARD * factor
		elif Input.is_action_pressed("cam_back"):
			position += Vector3.BACK * factor
		elif Input.is_action_pressed("cam_left"):
			position += Vector3.LEFT * factor
		elif Input.is_action_pressed("cam_right"):
			position += Vector3.RIGHT * factor


