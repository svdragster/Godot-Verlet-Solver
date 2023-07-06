extends Node2D

@export var spawn_rate := 0.3
@export var max_spawned := 35
var spawned := 0
var spawned_cubes := 0
var spawned_circles := 0
var time := 0.0

var radius_list := [40, 25, 30, 25, 30, 25, 25, 40, 60]
var size_list := [[70, 70], [100, 50], [100, 60], [50, 90], [90, 90]]

# Called when the node enters the scene tree for the first time.
func _ready():
	$VerletSolver2D.world_size = Vector2(250, 200)
	
	var floor = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	floor.position = Vector2(0, 200)
	$VerletSolver2D.add_child(floor)
	floor.set_size(1050, 40)
	floor.is_static = true
	
	var wall_left = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	wall_left.position = Vector2(-250, 0)
	$VerletSolver2D.add_child(wall_left)
	wall_left.set_size(40, 1000)
	wall_left.is_static = true
	
	var wall_right = preload("res://verlet2d/shapes/VerletRectangle2D.tscn").instantiate()
	wall_right.position = Vector2(250, 0)
	$VerletSolver2D.add_child(wall_right)
	wall_right.set_size(40, 1000)
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
			o.set_size(size[0], size[1])
			spawned_cubes += 1
		else:
			var o = preload("res://verlet2d/shapes/VerletCircle2D.tscn").instantiate()
			o.position = Vector2(150 * sin(spawned), -190)
			$VerletSolver2D.add_child(o)
			o.acceleration = Vector2(0.0, 0.0)
			o.set_radius(radius_list[spawned_circles % radius_list.size()])
			spawned_circles += 1
		
		spawned += 1
