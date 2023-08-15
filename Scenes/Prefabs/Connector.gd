extends Node3D
class_name Connector

signal pulsed(value: bool)

const TRUE_EMISSION_COLOR := Color.WEB_GREEN
const FALSE_EMISSION_COLOR := Color.DARK_RED

@onready var node := $Node

@onready var pulse_timer := $PulseTimer
@export var pulse_timer_wait_time := 1.0

@onready var pulse_light := $OmniLight3D

var _current_value := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pulse_timer.wait_time = pulse_timer_wait_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pulsed(value: bool):
	print("[Connector] - Pulse received.")
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	pulse_light.visible = true
	if value:
		material.emission = Color(TRUE_EMISSION_COLOR)
		material.albedo_color = Color(TRUE_EMISSION_COLOR, 0.3)
		pulse_light.light_color = Color(TRUE_EMISSION_COLOR)
	else:
		material.emission = Color(FALSE_EMISSION_COLOR)
		material.albedo_color = Color(FALSE_EMISSION_COLOR, 0.3)
		pulse_light.light_color = Color(FALSE_EMISSION_COLOR)
	
	$Node.material_overlay = material
	
	pulse_timer.start()
	_current_value = value
	pass # Replace with function body.


func _on_pulse_timer_timeout():
	$Node.material_overlay = null
	pulse_light.visible = false
	
	print("[Connector] - Pulsing.")
	pulsed.emit(_current_value)
	pass # Replace with function body.
