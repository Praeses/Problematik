extends Node3D

var extenders := []
var lasers := []

const extender_scene := preload("res://Scenes/Prefabs/Extender.tscn")
const laser_scene := preload("res://Scenes/Prefabs/Laser.tscn")

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
	extenders.append(extender)
	pass # Replace with function body.


func _on_player_extender_removed(extender):
	var filtered_lasers = _get_lasers_connected_to_connector(extender)
	for laser in filtered_lasers:
		lasers.erase(laser)
		laser.queue_free()
	extenders.erase(extender)
	extender.owner.owner.queue_free()
	pass # Replace with function body.


func _on_player_laser_connected(source, destination):
	var duplicates = lasers.filter(func (laser): return laser.source == source && laser.destination == destination)
	if(duplicates.is_empty()):
		var laser_instance = laser_scene.instantiate()
		add_child(laser_instance)
		laser_instance.set_source(source)
		laser_instance.set_destination(destination)
		lasers.append(laser_instance)
	else:
		print("[ConnectionHandler] - There was a duplicate laser :(")
	pass # Replace with function body.


func _on_player_laser_disconnected(node):
	var filtered_lasers = _get_lasers_connected_to_connector(node)
	for laser in filtered_lasers:
		lasers.erase(laser)
		laser.queue_free()
	pass # Replace with function body.


func _get_lasers_connected_to_connector(node):
	return lasers.filter(func(laser): return laser.source == node || laser.destination == node)
