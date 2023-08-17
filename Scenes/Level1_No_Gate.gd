extends Node3D

var pulse_idx := 0
var pulses := [true, false]
var expected_results := [true, false]

var results := []
var checking := false

signal pulsed(value: bool)

@onready var pulse_timer := $PulseCheckTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_clicked():
	if not checking:
		checking = true
		pulsed.emit(pulses[pulse_idx])
		pulse_idx += 1
		pulse_timer.start()
		
	pass # Replace with function body.


func _on_pulse_check_timer_timeout():
	results.clear()
	checking = false
	pass # Replace with function body.


func _on_unlocker_pulsed(value):
	results.append(value)
	if results.size() >= pulses.size():
		var success = true
		for i in range(0, results.size()):
			success = (results[i] == expected_results[i]) and success
		results.clear()
		checking = false
		
		if success:
			print("DING! You win!")
	else :
		pulsed.emit(pulses[pulse_idx])
		pulse_idx += 1
