extends Node2D

@export var spawn_rate := 0.3
@export var max_spawned := 35
var spawned := 0
var spawned_cubes := 0
var spawned_circles := 0
var time := 0.0

var radius_list := [1.0, 1.1, 0.9, 1.0]
var size_list := [[0.5, 0.5], [0.6, 0.5], [0.5, 0.6], [0.4, 0.4]]

# Called when the node enters the scene tree for the first time.
func _ready():
	$VerletSolver2D.world_size = Vector2(250, 200)
	
	var floor = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	floor.position = Vector2(0, 200)
	$VerletSolver2D.add_child(floor)
	floor.set_scale(Vector2(10, 0.2))
	floor.is_static = true
	
	var wall_left = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	wall_left.position = Vector2(-250, 0)
	$VerletSolver2D.add_child(wall_left)
	wall_left.set_scale(Vector2(0.2, 10))
	wall_left.is_static = true
	
	var wall_right = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	wall_right.position = Vector2(250, 0)
	$VerletSolver2D.add_child(wall_right)
	wall_right.set_scale(Vector2(0.2, 10))
	wall_right.is_static = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	time += delta
			
	if time >= spawn_rate and spawned < max_spawned:
		time -= spawn_rate
		
		if spawned % 2 == 1:
			var o = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
			o.position = Vector2(150 * sin(spawned), -190)
			$VerletSolver2D.add_child(o)
			o.acceleration = Vector2(0.0, 0.0)
			var size = size_list[spawned_cubes % size_list.size()]
			o.set_scale(Vector2(size[0], size[1]))
			spawned_cubes += 1
		else:
			var o = preload("res://verlet2d/shapes/VerletCircle2D.tscn").instantiate()
			o.position = Vector2(150 * sin(spawned), -190)
			$VerletSolver2D.add_child(o)
			o.acceleration = Vector2(0.0, 0.0)
			var scale = radius_list[spawned_circles % radius_list.size()]
			o.set_scale(Vector2(scale, scale))
			spawned_circles += 1
		
		spawned += 1
