extends Node3D

signal pulsed(value: bool)

var _state = false
@onready var camera = $Camera3D
var ray_length := 10.0

var src: Node3D = null
var dest: Node3D = null

var laser_scene := preload("res://Scenes/Prefabs/Laser.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		var mouse_pos = event.position
		var space_state = get_world_3d().get_direct_space_state()
		var query = PhysicsRayQueryParameters3D.new()
		query.from = camera.project_ray_origin(mouse_pos)
		query.to = query.from + camera.project_ray_normal(mouse_pos) * ray_length
		var collision = space_state.intersect_ray(query)
		if collision:
			print(str(collision))
			var target = collision["collider"].get_parent()
			if not src:
				src = target
#				print(src)
			elif not dest:
				dest = target
				var laser_instance = laser_scene.instantiate()
				add_child(laser_instance)
				laser_instance.set_source(src)
				laser_instance.set_destination(dest)
				
				src = null
				dest = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	pulsed.emit(_state)
	_state = !_state
	pass # Replace with function body.
