extends Node2D

@export var spawn_rate := 0.3
@export var max_spawned := 35
var spawned := 0
var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	time += delta
			
	if time >= spawn_rate and spawned < max_spawned:
		time -= spawn_rate
		
		var o = preload("res://verlet2d/shapes/VerletCircle2D.tscn").instantiate()
		o.position = Vector2(-190, -190)
		$VerletSolver2D.add_child(o)
		o.acceleration = Vector2(4000.0, 100.0)
		
		spawned += 1
