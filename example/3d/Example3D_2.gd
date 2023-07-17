extends Node3D



func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("up"):
		var sphere = $VerletSolver3D/VerletSphere3D
		sphere.acceleration.y = 10
	if Input.is_action_pressed("down"):
		var sphere = $VerletSolver3D/VerletSphere3D
		sphere.acceleration.y = -10
	if Input.is_action_pressed("right"):
		var sphere = $VerletSolver3D/VerletSphere3D
		sphere.acceleration.x = 10
	if Input.is_action_pressed("left"):
		var sphere = $VerletSolver3D/VerletSphere3D
		sphere.acceleration.x = -10
	if Input.is_action_pressed("reset"):
		var sphere = $VerletSolver3D/VerletSphere3D
		sphere.position.x = -1
		sphere.position.y = 3
		sphere.position.z = -2
		sphere.update_position(sphere.position)
