extends Node3D

signal pulsed(value: bool)

var _state = false
@onready var camera = $Camera3D
var ray_length := 10.0

var src: Node3D = null
var dest: Node3D = null

var laser_scene := preload("res://Scenes/Prefabs/Laser.tscn")
var lasers := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var mouse_pos = event.position
	if Input.is_action_just_pressed("left_click"):		
		var collision = _get_selected_object(mouse_pos)
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
				
				lasers.append(laser_instance)
	elif Input.is_action_just_pressed("right_click"):
		var collision = _get_selected_object(mouse_pos)
		if collision:
			print(str(collision))
			var target = collision["collider"].get_parent()
			var filtered_lasers = lasers.filter(func (laser): return laser.source == target || laser.destination == target)
			for l in filtered_lasers:
				l.queue_free()
		pass


func _get_selected_object(mouse_pos):	
	var space_state = get_world_3d().get_direct_space_state()
	var query = PhysicsRayQueryParameters3D.new()
	query.from = camera.project_ray_origin(mouse_pos)
	query.to = query.from + camera.project_ray_normal(mouse_pos) * ray_length
	return space_state.intersect_ray(query)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	pulsed.emit(_state)
	_state = !_state
	pass # Replace with function body.
