extends Node3D
class_name Laser

@onready var _mesh := $MeshInstance3D
@onready var laser_stream := $LaserStream

var source: Node3D
var destination: Node3D

signal pulsed(value: bool)


func set_source(source: Node3D):
	if source.owner is Connector:
		self.source = source
		source.owner.pulsed.connect(_on_pulsed)
		update()
		print("[Laser] - Source pulsed signal connected to Laser")
	else:
		print("[Laser] - Source not a Connector, skipping")


func remove_source():
	source.owner.pulsed.disconnect(_on_pulsed)
	source = null
	update()


func set_destination(destination: Node3D):
	if destination.owner is Connector:
		self.destination = destination
		pulsed.connect(self.destination.owner._on_pulsed)
		update()
		print("[Laser] - Laser pulsed signal connected to Destination")
	else:
		print("[Laser] - Destination not a Connector, skipping")


func remove_destination():
	destination = null
	pulsed.disconnect(destination.owner._on_pulsed)
	update()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update():
	if source:
		global_position = source.global_position
		print("Laser Source: " + str(position))
	
	if destination:
		print("Laser Destination: " + str(destination.global_position))
		look_at(destination.global_position)
		var distance = source.global_position.distance_to(destination.global_position)
		_mesh.mesh.height = distance
		var direction = source.global_position.direction_to(destination.global_position)
		
		_mesh.position.z = -distance/2
	
	if source != null and destination != null && !laser_stream.playing:
		laser_stream.play()
	pass


func _on_pulsed(value: bool):
	pulsed.emit(value)
