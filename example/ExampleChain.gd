extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var chain_piece_length := 48.0
	$VerletSolver2D.add_constraint(VerletChainConstraint2D.new(
		$VerletSolver2D/A,
		$VerletSolver2D/B,
		chain_piece_length
	))
	$VerletSolver2D.add_constraint(VerletChainConstraint2D.new(
		$VerletSolver2D/B,
		$VerletSolver2D/C,
		chain_piece_length
	))
	$VerletSolver2D.add_constraint(VerletChainConstraint2D.new(
		$VerletSolver2D/C,
		$VerletSolver2D/D,
		chain_piece_length
	))
	$VerletSolver2D.add_constraint(VerletChainConstraint2D.new(
		$VerletSolver2D/D,
		$VerletSolver2D/E,
		chain_piece_length
	))
	$VerletSolver2D.add_constraint(VerletChainConstraint2D.new(
		$VerletSolver2D/E,
		$VerletSolver2D/F,
		chain_piece_length + 10.0
	))
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spawn_object"):
		$VerletSolver2D/Bullet.update_position(get_global_mouse_position())
		var direction = ($VerletSolver2D/A.position - get_global_mouse_position()).normalized()
		direction.x *= 3000
		direction.y *= 10
		$VerletSolver2D/Bullet.acceleration = direction
