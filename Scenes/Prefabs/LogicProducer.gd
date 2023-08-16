extends Node3D
signal pulsed(value: bool)

@onready var connector: Connector = $Connector

# Called when the node enters the scene tree for the first time.
func _ready():
	pulsed.connect(connector._on_pulsed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pulsed(value: bool):
	pulsed.emit(false)
	print("Pulsed")
	pass
