extends Node3D

var pulse_idx := 0
var pulses := [
	[true, true],
	[true, false],
	[false, true],
	[false, false],
]
var expected_results := [false, true, true, true]

var results := []
var checking := false

signal pulsed_1(value: bool)
signal pulsed_2(value: bool)
signal puzzle_solved()

@onready var pulse_timer := $PulseCheckTimer
@onready var button := $Button
@onready var unlocker := $Unlocker
@onready var connector_handler := $ConnectorHandler
@onready var logic_producer1 := $LogicProducer1
@onready var logic_producer2 := $LogicProducer2
@onready var door := $LeDoor

@export var pulse_timeout := 30


# Called when the node enters the scene tree for the first time.
func _ready():
	button.clicked.connect(_on_button_clicked)
	pulse_timer.timeout.connect(_on_pulse_check_timer_timeout)
	pulse_timer.wait_time = pulse_timeout
	unlocker.pulsed.connect(_on_unlocker_pulsed)
	pulsed_1.connect(logic_producer1._on_pulsed)
	pulsed_2.connect(logic_producer2._on_pulsed)
	puzzle_solved.connect(door._open)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_clicked():
	if not checking:
		checking = true
		pulse_idx = 0
		var to_pulse = pulses[pulse_idx]
		pulsed_1.emit(to_pulse[0])
		pulsed_2.emit(to_pulse[1])
		pulse_idx += 1
		pulse_timer.start()
		
	pass # Replace with function body.


func _on_pulse_check_timer_timeout():
	results.clear()
	checking = false
	pass # Replace with function body.


func _on_unlocker_pulsed(value):
	results.append(value)
	print("Number of results: " + str(results.size()))
	if results.size() >= pulses.size() or pulse_idx >= pulses.size():
		var success = true
		for i in range(0, results.size()):
			success = (results[i] == expected_results[i]) and success
		results.clear()
		checking = false
		
		if success:
			puzzle_solved.emit()
			print("DING! You win!")
	else :
		var to_pulse = pulses[pulse_idx]
		pulsed_1.emit(to_pulse[0])
		pulsed_2.emit(to_pulse[1])
		pulse_idx += 1
