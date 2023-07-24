extends Node3D

var colors = [Color.RED, Color.GREEN_YELLOW, Color.DARK_BLUE, Color.REBECCA_PURPLE, Color.DARK_GREEN, Color.DARK_GOLDENROD, Color.DARK_TURQUOISE]

func _ready():
	var color_index := 0
	for child in get_node("VerletSolver3D").get_children():
		if child is VerletSphere3D:
			var mesh : Mesh = child.get_node("MeshInstance3D").mesh.duplicate()
			child.get_node("MeshInstance3D").mesh = mesh
			var material := StandardMaterial3D.new()
			material.albedo_color = colors[color_index]
			mesh.material = material
			
			color_index += 1
			if color_index >= colors.size():
				color_index = 0

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
