extends VerletObject3D

class_name VerletPlane3D


func _ready():
	super._ready()
	is_static = true
	
	# Normal vector of plane
	get_node("/root/Example3D_1/DebugCamera3D/DebugDraw").add_vector(position, position + basis.y.normalized(), 4, Color.BLUE)
	
	# x Edges of this plane
	#get_node("/root/Example3D_1/DebugCamera3D/DebugDraw").add_vector(position + basis.x + basis.z, position + basis.x - basis.z, 2, Color.ORANGE_RED)
	#get_node("/root/Example3D_1/DebugCamera3D/DebugDraw").add_vector(position - basis.x - basis.z, position - basis.x + basis.z, 2, Color.ORANGE)
	
	# z Edges of this plane
	get_node("/root/Example3D_1/DebugCamera3D/DebugDraw").add_vector(position + basis.z - basis.x, position + basis.z + basis.x, 2, Color.ORANGE)
	get_node("/root/Example3D_1/DebugCamera3D/DebugDraw").add_vector(position - basis.z + basis.x, position - basis.z - basis.x, 2, Color.ORANGE)
	

func update(delta : float) -> void:
	pass

