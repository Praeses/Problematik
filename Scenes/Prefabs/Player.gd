extends CharacterBody3D
class_name Player


signal gate_added(position: Vector3, normal: Vector3, type: int)
signal gate_removed(extender: Node3D)

signal laser_connected(source: Node3D, destination: Node3D)
signal laser_disconnected(node: Node3D)

const LASER := 0
const EXTENDER := 1
const NOTTER := 2
const ANDER := 3
const ORER := 4

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity = 0.001
var twist_input := 0.0
var pitch_input := 0.0
var tool_index := 0
var new_tool_index := 0
var switching_tool := false

var _source: Node3D = null
var _destination: Node3D = null


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var twist := $Twist
@onready var pitch := $Twist/Pitch
@onready var tool_bar_hud := [
	$ToolHud/Tool1,
	$ToolHud/Tool2,
	$ToolHud/Tool3,
	$ToolHud/Tool4,
	$ToolHud/Tool5
]
@onready var tool_animation_player := $Twist/Pitch/Tool/AnimationPlayer
@onready var tools := [
	$Twist/Pitch/Tool/Tool1, 
	$Twist/Pitch/Tool/Tool2, 
	$Twist/Pitch/Tool/Tool3, 
	$Twist/Pitch/Tool/Tool4,
	$Twist/Pitch/Tool/Tool5
]

func _input(event):
	if Input.is_action_just_pressed("left_click") && !switching_tool:
		var ray_result = tools[tool_index].fire_ray()
		if ray_result.has("collider") && ray_result.has("normal") && ray_result.has("point"):
			var collider = ray_result["collider"]
			var normal = ray_result["normal"]
			var point = ray_result["point"]
			
			if tool_index == LASER:
				if collider.is_in_group("Connector"):
					if _source == null:
						_source = collider
					elif _destination == null:
						_destination = collider
						laser_connected.emit(_source, _destination)
						_source = _destination
						_destination = null
					else:
						_destination = collider
						laser_connected.emit(_source, _destination)
				pass
			elif tool_index == EXTENDER:
				if not collider.is_in_group("Connector"):
					gate_added.emit(point, normal, EXTENDER)
			elif tool_index == NOTTER:
				if not collider.is_in_group("Connector"):
					gate_added.emit(point, normal, NOTTER)
			elif tool_index == ANDER:
				if not collider.is_in_group("Connector"):
					gate_added.emit(point, normal, ANDER)
				pass
			elif tool_index == ORER:
				if not collider.is_in_group("Connector"):
					gate_added.emit(point, normal, ORER)
				pass
			print(ray_result)
	elif Input.is_action_just_pressed("right_click") && !switching_tool:
		var ray_result = tools[tool_index].fire_ray()
		if ray_result.has("collider") && ray_result.has("normal") && ray_result.has("point"):
			var collider = ray_result["collider"]
			var normal = ray_result["normal"]
			var point = ray_result["point"]
			
			if tool_index == LASER:
				if _source != null:
					_source = null
				else:
					if collider.is_in_group("Connector"):
						laser_disconnected.emit(collider)
			elif tool_index == EXTENDER:
				if collider.is_in_group("Connector") && collider.owner.owner is Extender:
					gate_removed.emit(collider)
			elif tool_index == NOTTER:
				if collider.is_in_group("Connector") && collider.owner.owner is NotGate:
					gate_removed.emit(collider)
			elif tool_index == ANDER:
				if collider.is_in_group("Connector") && collider.owner.owner is AndGate:
					gate_removed.emit(collider)
			elif tool_index == ORER:
				if collider.is_in_group("Connector") && collider.owner.owner is OrGate:
					gate_removed.emit(collider)
			pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tool_bar_hud[0].modulate = Color.PURPLE

func _process(delta):
	if Input.is_action_just_pressed("swtich_tool_1") and !switching_tool:
		new_tool_index = 0
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_2") and !switching_tool:
		new_tool_index = 1
		switch_tool()
		
	if Input.is_action_just_pressed("swtich_tool_3") and !switching_tool:
		new_tool_index = 2
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_4") and !switching_tool:
		new_tool_index = 3
		switch_tool()

	if Input.is_action_just_pressed("swtich_tool_5") and !switching_tool:
		new_tool_index = 4
		switch_tool()

func switch_tool():
	tool_animation_player.play("Holster")
	switching_tool = true


func _physics_process(delta):
	#TODO: Not sure if we need this here but this frees up the mouse on an escape button press
	#	could be useful to tirgger a menu to pop up as well
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_back")
	var direction = (twist.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	twist.rotate_y(twist_input)
	pitch.rotate_x(pitch_input)
	pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Holster"):
		tools[tool_index].hide()
		tool_bar_hud[tool_index].modulate = Color.WHITE
		tools[new_tool_index].show()
		tool_bar_hud[new_tool_index].modulate = Color.PURPLE
		tool_index = new_tool_index
		tool_animation_player.play("Draw")
	if(anim_name == "Draw"):
		switching_tool = false
