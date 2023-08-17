extends Node3D

var gate_list := []
var lasers := []

const extender_scene := preload("res://Scenes/Prefabs/Extender.tscn")
const not_gate_scene := preload("res://Scenes/Prefabs/NotGate.tscn")
const and_gate_scene := preload("res://Scenes/Prefabs/AndGate.tscn")
const or_gate_scene := preload("res://Scenes/Prefabs/OrGate.tscn")
const laser_scene := preload("res://Scenes/Prefabs/Laser.tscn")

const EXTENDER := 1
const NOT_GATE := 2
const AND_GATE := 3
const OR_GATE := 4

@onready var placer_stream := $PlacerStream

const gate_dict = {
	EXTENDER = extender_scene,
	NOT_GATE = not_gate_scene,
	AND_GATE = and_gate_scene,
	OR_GATE = extender_scene # TODO: Add or gate
}

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
	var player = owner.find_child("Player") as Player
	if player:
		player.gate_added.connect(_on_player_gate_added)
		player.gate_removed.connect(_on_player_gate_removed)
		player.laser_connected.connect(_on_player_laser_connected)
		player.laser_disconnected.connect(_on_player_laser_disconnected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_gate_instance(type: int):
	if type == EXTENDER:
		return extender_scene.instantiate()
	elif type == NOT_GATE:
		return not_gate_scene.instantiate()
	elif type == AND_GATE:
		return and_gate_scene.instantiate()
	elif type == OR_GATE:
		return or_gate_scene.instantiate()
	pass


func _on_player_gate_added(position: Vector3, normal: Vector3, type: int):
	var gate = _get_gate_instance(type)
	add_child(gate)
	gate.position = position
	gate.look_at(normal)
	gate.global_transform.basis = align_up(gate.global_transform.basis, normal)
	gate_list.append(gate)
	placer_stream.play()
	pass # Replace with function body.


func _on_player_gate_removed(node):
	var node_owner = node.owner.owner
	var nodes = node_owner.get_connectable_nodes()
	for _node in nodes:
		var filtered_lasers = _get_lasers_connected_to_connector(_node)
		for laser in filtered_lasers:
			lasers.erase(laser)
			laser.queue_free()
	gate_list.erase(node)
	node.owner.owner.queue_free()
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
