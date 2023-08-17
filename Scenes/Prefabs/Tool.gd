extends MeshInstance3D
class_name Tool

@export var tool_reach := 20.0
@onready var raycast := $RayCast3D
@export var tool_name := "Tool ?"

# Called when the node enters the scene tree for the first time.
func _ready():
	raycast.target_position.z = abs(tool_reach) * -1
	$Label3D.text = tool_name
	$MeshInstance3D.mesh.height = abs(tool_reach)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fire_ray() -> Dictionary:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var normal = raycast.get_collision_normal()
		var collision_point = raycast.get_collision_point()
		
		return {
			"collider": collider,
			"normal": normal,
			"point": collision_point
		}
	else:
		return {}
