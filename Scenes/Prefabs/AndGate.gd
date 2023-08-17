extends Node3D
class_name AndGate

signal pulsed(value: bool)

var _state = false
var _input1_state = false;
var _received_input1_value = false;
var _input2_state = false;
var _received_input2_value = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_connector_1_pulsed(value):
	_input1_state = value
	_received_input1_value = true
	if _received_input1_value and _received_input2_value:
		inputs_full()


func _on_input_connector_2_pulsed(value):
	_input2_state = value
	_received_input2_value = true
	if _received_input1_value and _received_input2_value:
		inputs_full()

func inputs_full():
	if _input1_state and _input2_state:
		_state = true
	else:
		_state = false
	
	_received_input1_value = false
	_received_input2_value = false
	pulsed.emit(_state)
