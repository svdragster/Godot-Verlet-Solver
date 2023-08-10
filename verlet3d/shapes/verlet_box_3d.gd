extends VerletObject3D

class_name VerletBox3D

var last_rotation : Vector3 = Vector3.ZERO
var angular_acceleration : Vector3 = Vector3.ZERO

var friction : float = 0.99

func _ready():
	super._ready()
	last_rotation = rotation
	
	# Normal vectors of box
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2, position + basis.y*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2, position - basis.y*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.x/2, position + basis.x*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.x/2, position - basis.x*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.z/2, position + basis.z*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.z/2, position - basis.z*1.5, 4, Color.BLUE)
#	var box = self
#	var box_basis_list : Array[Basis] = [
#		Basis(box.basis),
#		Basis(box.basis.x, -box.basis.y, box.basis.z),
#		Basis(box.basis.y, box.basis.x, box.basis.z),
#		Basis(box.basis.y, -box.basis.x, box.basis.z),
#		Basis(box.basis.x, box.basis.z, box.basis.y),
#		Basis(box.basis.x, -box.basis.z, box.basis.y),
#	]
#	for b in box_basis_list:
#		get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + b.y/2, position + b.y*1.5, 4, Color.BLUE)
	
#	# Top edges of this box
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 + basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 + basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 - basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 - basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#
#	# Bottom edges of this box
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 + basis.z/2, position - basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 - basis.z/2, position - basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 - basis.z/2, position - basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 + basis.z/2, position - basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#
#	# Vertical edges of this box
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 + basis.z/2, position + basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 - basis.z/2, position + basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
#

func update(delta : float) -> void:
	if is_static:
		return
		
	# Velocity
	var velocity : Vector3 = (position - last_position) * friction
	var new_position : Vector3 = position + velocity + (acceleration) * (delta * delta)
	
	last_position = position
	position = new_position
	
	
	# Rotation
	update_rotation(delta)
	
	# Reset
	friction = 0.99
	acceleration = Vector3.ZERO
	angular_acceleration = Vector3.ZERO


func update_rotation(delta : float):
	var angular_velocity : Vector3 = (rotation - last_rotation) * friction
	if angular_velocity.length_squared() < 0.0005:
		angular_velocity = Vector3.ZERO
		last_rotation = rotation
	var new_rotation : Vector3 = rotation + angular_velocity + (angular_acceleration) * (delta * delta)
	
	last_rotation = rotation
	rotation = new_rotation
