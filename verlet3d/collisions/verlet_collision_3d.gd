@tool
extends Node3D

class_name VerletCollision3D

@export var shape : Shape3D:
	set(new_value):
		if shape == new_value:
			return
		shape = new_value	
		update()
		

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(Engine.is_editor_hint())
	if Engine.is_editor_hint():
		update()
	else:
		get_parent().shape = self.shape
		queue_free()

func update():
	if Engine.is_editor_hint():
		if has_node("EditorShape"):
			get_node("EditorShape").name = "EditorShapeX"
			get_node("EditorShapeX").queue_free()
		if shape is SphereShape3D:
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.name = "EditorShape"
			mesh_instance.mesh = SphereMesh.new()
			mesh_instance.mesh.radius = shape.radius
			mesh_instance.mesh.height = shape.radius * 2.0
			mesh_instance.material_override = StandardMaterial3D.new()
			mesh_instance.material_override.transparency = BaseMaterial3D.Transparency.TRANSPARENCY_ALPHA
			mesh_instance.material_override.albedo_color = Color(Color.BLUE, 0.3)
			add_child(mesh_instance)
		
func _process(delta):
	if Engine.is_editor_hint():
		if shape is SphereShape3D:
			if has_node("EditorShape"):
				var mesh_instance = get_node("EditorShape")
				mesh_instance.mesh.radius = shape.radius
				mesh_instance.mesh.height = shape.radius * 2.0
