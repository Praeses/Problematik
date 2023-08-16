extends Node3D

var extenders := []

const extender_scene := preload("res://Scenes/Prefabs/Extender.tscn")

func align_up(node_basis, normal):
	var result = Basis()
	var scale = node_basis.get_scale().abs()

	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x #
	result.y *= scale.y #
	result.z *= scale.z #

	return result


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_extender_added(position: Vector3, normal: Vector3):
	var extender = extender_scene.instantiate()
	add_child(extender)
	extender.position = position
	extender.look_at(normal)
	extender.global_transform.basis = align_up(extender.global_transform.basis, normal)
	pass


func _on_player_extender_added(position, normal):
	var extender = extender_scene.instantiate()
	add_child(extender)
	extender.position = position
	extender.look_at(normal)
	extender.global_transform.basis = align_up(extender.global_transform.basis, normal)
	pass # Replace with function body.
