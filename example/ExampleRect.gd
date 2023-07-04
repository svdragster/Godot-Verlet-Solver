extends Node2D

@export var spawn_rate := 0.3
@export var max_spawned := 35
var spawned := 0
var time := 0.0

var simulate := false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var o = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	o.position = Vector2(0, 70)
	$VerletSolver2D.add_child(o)
	o.set_size(1050, 60)
	o.is_static = true
	
#	var o2 = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
#	o2.position = Vector2(0, 0)
#	$VerletSolver2D.add_child(o2)
#	o2.set_size(100, 60)
#
#	var o3 = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
#	o3.position = Vector2(50, -80)
#	$VerletSolver2D.add_child(o3)
#	o3.set_size(100, 60)
#
#	var o4 = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
#	o4.position = Vector2(50, -150)
#	$VerletSolver2D.add_child(o4)
#	o4.set_size(100, 60)
	
	$VerletSolver2D.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_just_pressed("toggle_simulation"):
		simulate = !simulate
	
	if Input.is_action_just_pressed("next_step") or simulate:
		$VerletSolver2D._physics_process(delta)
		
	if Input.is_action_just_pressed("spawn_object"):
		var o = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
		o.position = get_global_mouse_position()
		$VerletSolver2D.add_child(o)
		o.set_size(100, 100)
	
#	time += delta
#
#	if time >= spawn_rate and spawned < max_spawned:
#		time -= spawn_rate
#
#		var o = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
#		o.position = Vector2(-190, -190)
#		$VerletSolver2D.add_child(o)
#		o.acceleration = Vector2(4000.0, 100.0)
#		o.set_size(100, 60)
#		o.angular_acceleration = 1
#
#		spawned += 1
