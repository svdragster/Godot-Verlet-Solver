extends VerletObject3D

class_name VerletBox3D


func _ready():
	super._ready()
	is_static = true
	
	# Normal vectors of box
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2, position + basis.y*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2, position - basis.y*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.x/2, position + basis.x*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.x/2, position - basis.x*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.z/2, position + basis.z*1.5, 4, Color.BLUE)
#	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.z/2, position - basis.z*1.5, 4, Color.BLUE)
	var box = self
	var box_basis_list : Array[Basis] = [
		Basis(box.basis),
		Basis(box.basis.x, -box.basis.y, box.basis.z),
		Basis(box.basis.y, box.basis.x, box.basis.z),
		Basis(box.basis.y, -box.basis.x, box.basis.z),
		Basis(box.basis.x, box.basis.z, box.basis.y),
		Basis(box.basis.x, -box.basis.z, box.basis.y),
	]
	for b in box_basis_list:
		get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + b.y/2, position + b.y*1.5, 4, Color.BLUE)
	
	# Top edges of this box
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 + basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 + basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 - basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position + basis.y/2 - basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	
	# Bottom edges of this box
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 + basis.z/2, position - basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 - basis.z/2, position - basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 - basis.z/2, position - basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 + basis.z/2, position - basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	
	# Vertical edges of this box
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 + basis.z/2, position + basis.y/2 + basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 + basis.z/2, position + basis.y/2 - basis.x/2 + basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 - basis.x/2 - basis.z/2, position + basis.y/2 - basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	get_node("/root/Example3D_Box_1/DebugCamera3D/DebugDraw").add_vector(position - basis.y/2 + basis.x/2 - basis.z/2, position + basis.y/2 + basis.x/2 - basis.z/2, 2, Color.ORANGE_RED)
	

func update(delta : float) -> void:
	pass

