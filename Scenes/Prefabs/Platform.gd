extends CharacterBody3D

@export var distance: float = 10.0	# Number of units the platform will travel
@export var direction: Vector3 = Vector3(0, 0, 1)	# Movement direction (normalized in _ready())
@export var speed: float = 50.0

@onready var stream := $WahWahStream

var starting_point: Vector3
var target_point: Vector3
var current_direction: Vector3

func _ready():
	direction = direction.normalized()
	starting_point = global_transform.origin
	target_point = starting_point + direction * distance
	current_direction = direction	# Initial direction
	stream.play()

func _physics_process(delta):
	var move_vec = current_direction * speed * delta

	if global_transform.origin.distance_to(target_point) <= move_vec.length():
#		global_transform.origin = target_point
		
		# Swap starting and target points
		var temp = target_point
		target_point = starting_point
		starting_point = temp
		
		# Reverse the movement direction
		current_direction = -current_direction
	else:
		#translate(move_vec)
		velocity = move_vec
		move_and_slide()
