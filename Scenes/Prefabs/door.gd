extends Node3D

# Reference the two MeshInstances
@onready var mesh1: MeshInstance3D = $Mesh1
@onready var mesh2: MeshInstance3D = $Mesh2

# Reference the collision shapes for each mesh
@onready var collision1: CollisionShape3D = $Mesh1/doorClosed/doorClosed2/StaticBody3D/CollisionShape3D
@onready var collision2: CollisionShape3D = $Mesh2/doorOpen/doorOpen2/StaticBody3D/CollisionShape3D

# Use a flag to track the current active mesh
var is_mesh1_active: bool = true

func _ready():
	# Ensure only Mesh1 is visible at start
	mesh1.visible = true
	mesh2.visible = false

	# Enable collision for Mesh1 and disable for Mesh2 at start
	collision1.set_disabled(false)
	collision2.set_disabled(true)

func _input(event):
	# Check for a key press (e.g., the Space key)
	if Input.is_key_pressed(KEY_O):
		_toggle_mesh()

func _toggle_mesh():
	is_mesh1_active = !is_mesh1_active  # Flip the active flag

	mesh1.visible = is_mesh1_active
	mesh2.visible = !is_mesh1_active

	# Toggle the collisions as well
	collision1.set_disabled(!is_mesh1_active)
	collision2.set_disabled(is_mesh1_active)
