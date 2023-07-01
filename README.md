# Godot Verlet Solver
A Verlet Algorithm implemented in Godot 4 with some examples. My long term goal is to create a deterministic physics simulation where an equal input always results in the same output.

## Example
When running the simulation with the exact same input, the circles will always end up in the same positions with the same rotations:

https://github.com/svdragster/GodotVerletSolver/assets/3999238/b18fa05c-b629-477a-86df-e77f8f8b2550

Examples can be found in the `example` directory.

## How it works

### [verlet_solver_2d](https://github.com/svdragster/GodotVerletSolver/blob/main/verlet2d/verlet_solver_2d.gd)
All children are updated in `_physics_process` with multiple substeps. `_physics_process` is run with a fixed timestep (default is 60 times per second).

### [verlet_object_2d](https://github.com/svdragster/GodotVerletSolver/blob/main/verlet2d/verlet_object_2d.gd)
This is the main implementation of the algorithm. The next position is always based on the last position.
```gdscript
func update(delta : float):
  var velocity : Vector2 = (position - last_position) * friction
  var new_position : Vector2 = position + velocity + (acceleration*40) * (delta * delta)
  [...]
```

### Collisions
Using Godots Shape objects, I implemented a basic CircleShape2D collision handling. 
```gdscript
var collision : Vector2 = object_a.position - object_b.position
var radius = shape_a.radius + shape_b.radius
if collision.length_squared() < radius*radius:
  # push the objects away from eachother
  # if they barely touch, the force will be very small
```

## Limitations
Currently, Godot 64-bit double-precision floats are used for calculations (equal to double in C++). For data structures such as Vector2 and Vector3, Godot uses 32-bit floating-point numbers (Source: https://docs.godotengine.org/de/stable/classes/class_float.html).
This could result in different behaviour on different machines. My long term goal is to use fixed point numbers so the calculations will behave the same on all systems.

## Goals
Not necessarily in order
- [ ] support more shapes for collisions
- [ ] use chunk system for collisions
- [ ] multithreading chunks
- [ ] 3d implementation
- [ ] add fixed point numbers
- [ ] Implement in GDExtension (C++) for better performance
