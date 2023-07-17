# Godot Verlet Solver
A Verlet Algorithm implemented in Godot 4 with some examples. My long term goal is to create a deterministic physics engine where an equal input always results in the same output.

## Example
When running the simulation with the exact same input, the circles will always end up in the same positions with the same rotations:

https://github.com/svdragster/GodotVerletSolver/assets/3999238/b18fa05c-b629-477a-86df-e77f8f8b2550

Examples can be found in the `example` directory.

## How it works

### [verlet_solver_2d](https://github.com/svdragster/GodotVerletSolver/blob/main/verlet2d/verlet_solver_2d.gd)
All children are updated in `_physics_process` with multiple substeps. `_physics_process` is run with a fixed timestep (default is 60 times per second).
```gdscript
func _physics_process(delta : float) -> void:
	var sub_delta : float = delta / substeps
	for i in range(substeps):
		check_collisions(sub_delta)
		update_constraints(sub_delta)
	update_objects(delta)	
```

### [verlet_object_2d](https://github.com/svdragster/GodotVerletSolver/blob/main/verlet2d/verlet_object_2d.gd)
This is the main implementation of the algorithm. The next position is always based on the last position.
```gdscript
func update(delta : float):
  var velocity : Vector2 = (position - last_position) * friction
  var new_position : Vector2 = position + velocity + (acceleration*40) * (delta * delta)
  [...]
```

### [Collisions](https://github.com/svdragster/GodotVerletSolver/blob/main/verlet2d/collisions/verlet_collision_solver_2d.gd)
Using Godots Shape objects, I implemented a basic collision handling to update velocity and angular velocity. 
```gdscript
var contacts := shape_a.collide_and_get_contacts(object_a.transform, shape_b, object_b.transform)
var contact_amount = contacts.size() / 2
if contact_amount >= 1:
  for i in range(0, contacts.size(), 2):
    # Solve collision
```

## Limitations
1. It's currently not very realistic. Using more realistic equations (friction, intertia, mass) to solve collisions should be pretty easy to implement.
2. Currently, Godot 64-bit double-precision floats are used for calculations (equal to double in C++). For data structures such as Vector2 and Vector3, Godot uses 32-bit floating-point numbers (Source: https://docs.godotengine.org/de/stable/classes/class_float.html). This could result in different behaviour on different machines. My long term goal is to use fixed point numbers so the calculations will behave the same on all systems.

## Goals
These are somwhat in order
- [ ] WIP: support more shapes for collisions (2d currently supports spheres and rectangles, see directory `verlet2d/shapes`)
- [ ] WIP: 3d implementation (see branch `3d` [https://github.com/svdragster/GodotVerletSolver/tree/3d/verlet3d](https://github.com/svdragster/GodotVerletSolver/tree/3d/verlet3d))
- [ ] add fixed point numbers
- [ ] use chunk system for collisions
- [ ] multithreading chunks
- [ ] Implement in GDExtension (C++) for better performance
