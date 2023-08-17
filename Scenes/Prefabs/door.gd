extends Node3D

# Reference the two MeshInstances
@onready var mesh1: MeshInstance3D = $Mesh1
@onready var mesh2: MeshInstance3D = $Mesh2
@onready var doorPortal := $Mesh2/doorPortal

# Reference the collision shapes for each mesh
@onready var collision1: CollisionShape3D = $Mesh1/doorClosed/doorClosed2/StaticBody3D/CollisionShape3D
@onready var collision2: CollisionShape3D = $Mesh2/doorOpen/doorOpen2/StaticBody3D/CollisionShape3D
@onready var portal_collision := $Mesh2/Area3D/CollisionShape3D

@export var debug_key_enabled := false

signal area_entered()

# Use a flag to track the current active mesh
var is_mesh1_active: bool = true

func _ready():
	# Ensure only Mesh1 is visible at start
	mesh1.visible = true
	mesh2.visible = false
	doorPortal.visible = false

	# Enable collision for Mesh1 and disable for Mesh2 at start
	collision1.set_disabled(false)
	collision2.set_disabled(true)
	portal_collision.set_disabled(true)

func _input(event):
	# Check for a key press (e.g., the Space key)
	if Input.is_key_pressed(KEY_O) and debug_key_enabled:
		_toggle_mesh()

func _toggle_mesh():
#	is_mesh1_active = !is_mesh1_active  # Flip the active flag
	_set_mesh(!is_mesh1_active)

func _set_mesh(value: bool):
	is_mesh1_active = value
	mesh1.visible = is_mesh1_active
	mesh2.visible = !is_mesh1_active
	doorPortal.visible = mesh2.visible

	# Toggle the collisions as well
	collision1.set_disabled(!is_mesh1_active)
	collision2.set_disabled(is_mesh1_active)
	portal_collision.set_disabled(is_mesh1_active)

func _open():
	_set_mesh(false)


func _on_area_3d_body_entered(body):
	area_entered.emit()
	pass # Replace with function body.
