extends Node3D

signal pulsed(value: bool)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_connector_pulsed(value):
	pulsed.emit(value)
