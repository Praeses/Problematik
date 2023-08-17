extends Node3D
class_name NotGate

signal pulsed(value: bool)

var _state = false

func get_connectable_nodes():
	return [$InputConnector/Node/StaticBody3D, $OutputConnector/Node/StaticBody3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_connector_pulsed(value):
	_state = !value
	pulsed.emit(_state)
