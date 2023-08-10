extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spawn_object"):
		var sphere = preload("res://verlet3d/shapes/verlet_sphere_3d.tscn").instantiate()
		sphere.position = Vector3(0, 4, 0)
		$VerletSolver3D.add_child(sphere)
		
	$VerletSolver3D/VerletBox3D.update_position(Vector3(0, 1, 0.5))
